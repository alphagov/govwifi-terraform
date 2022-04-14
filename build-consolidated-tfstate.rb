# Example of using this for staging
# ruby build-consolidated-tfstate.rb staging-dublin-tfstate staging-london-tfstate > govwifi/staging/terraform.tfstate

require "pp"
require "json"

dublin_state_file, london_state_file = ARGV[0..2]

def log(s)
  STDERR.puts s
end

log "Dublin state file: #{dublin_state_file}"
log "London state file: #{london_state_file}"

dublin_state = JSON.parse(File.read(dublin_state_file))
london_state = JSON.parse(File.read(london_state_file))

def alter_resource!(resource, region_module_prefix, main_provider_replacement)
  if resource["provider"].end_with? ".main"
    resource["provider"] = "#{resource["provider"][0...-4]}#{main_provider_replacement}"
  end

  if resource["module"] && !resource["module"].end_with?(".emails")
    if resource["module"].start_with? "module.govwifi_"
      resource["module"] = "module.#{resource["module"][15...]}"
    end

    if !%w[module.datasync].include?(resource["module"])
      old_module = resource["module"]
      resource["module"] = "module.#{region_module_prefix}#{resource["module"][7..]}"

      full_name = resource.values_at("module", "mode", "type", "name").join "."
      log "changed #{old_module} to #{resource["module"]} for #{full_name}"
    end

    for instance in resource["instances"]
      instance["dependencies"]&.map! do |dependency|
        if dependency.start_with? "module."
          components = dependency.split "."
          components[1] = "#{region_module_prefix}#{components[1]}"
          components.join "."
        else
          dependency
        end
      end
    end
  end

  resource
end

def filter_resources!(resources)
  resources.delete_if do |resource|
    delete = false

    if ["module.tfstate"].include? resource["module"]
      delete = true
    end

    delete
  end

  resources
end

def deduplicate_resources!(resources)
  seen_aws_caller_identity = false
  resources_by_arn_attribute = {}
  data_by_arn_attribute = {}
  secrets_by_name = {}

  resources.delete_if do |resource|
    instances = resource["instances"]
    next unless instances.length == 1

    # This resource seems to have a confusing ARN, which matches the
    # ARN of the related cluster
    next if %w[auth_ecs_target aws_cloudwatch_event_target].include? resource["type"]

    # id is a timestamp
    next if resource["type"] == "aws_acm_certificate_validation"

    # The id of this resource is confusing
    next if resource["type"] == "auth_ecs_target"

    # Id is duplicated with another resource
    next if resource["type"] == "aws_iam_role_policy"

    # Terraform has been tricked in to managing this twice, from both
    # statefiles, so continue the pretence here
    next if %[elb_global_cert_validation aws_cloudwatch_log_metric_filter aws_cloudwatch_dashboard aws_route53_record aws_appautoscaling_target].include? resource["type"]

    full_name = resource.values_at("module", "mode", "type", "name").join "."

    delete = false

    if resource["type"] == "aws_caller_identity"
      if seen_aws_caller_identity
        delete = true
      else
        seen_aws_caller_identity = true
      end
    elsif %w[aws_secretsmanager_secret aws_secretsmanager_secret_version].include? resource["type"]
      name = resource["name"]
      if secrets_by_name[name]
        delete = true
      else
        secrets_by_name[name] = true
      end
    else
      arn = instances[0]["attributes"]["arn"] || instances[0]["attributes"]["id"]
      hash = resource["mode"] == "managed" ? resources_by_arn_attribute : data_by_arn_attribute

      if hash[arn]
        log "found existing resource with arn #{arn}"
        delete = true
      else
        hash[arn] = true
      end
    end

    if delete
      log "removing duplicate #{full_name}"
    else
      log "keeping #{full_name}"
    end

    delete
  end

  resources
end

consolidated_state = {
  version: 4,
  terraform_version: "1.0.11",
  outputs: {},
  resources: deduplicate_resources!(
    filter_resources!(london_state["resources"]).map! { |r| alter_resource!(r, "london_", "london") } +
    filter_resources!(dublin_state["resources"]).map! { |r| alter_resource!(r, "dublin_", "dublin") }
  )
}

puts JSON.pretty_generate(consolidated_state)
