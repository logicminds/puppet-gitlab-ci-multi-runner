class gitlab_ci_multi_runner(
  Hash[String, Hash] $runner_instances,
  String $default_ci_token,
  String $default_gitlab_ci_url = 'https://gitlab.com/ci',
  Array[String] $default_tags = ['puppet', 'rspec-puppet'],
  String $default_executor = 'shell'
) {

  $runner_instances.each |String $user, $options| {
      $toml_file_path = "/home/${user}/.gitlab-runner/config.toml"
      $instance_parameters = merge({'user' => $user, 'toml_file_path' => $toml_file_path},$options['instance_parameters'])
      create_resources(gitlab_ci_multi_runner::instance, {$user => $instance_parameters})
      # if the instance options do not specify the required options, defaults will be used
      # otherwise the defaults will be overridden.
      $runner_options = merge({'user' => $user, 'toml_file' => $toml_file_path,
        'gitlab_ci_url' => $default_gitlab_ci_url, 'token' => $default_ci_token,
        'require' => Gitlab_ci_multi_runner::Instance[$user],
        'tags' => $default_tags,
        'executor' => $default_executor}, $options['runner_parameters'])
      create_resources(gitlab_ci_multi_runner::runner, {"gitlab_runner_${user}" => $runner_options})

  }

}
