

class{'gitlab_ci_multi_runner':
  runner_instances => {
    'user229' => {}
  },
  default_ci_token => '5de6ea0f8f25b545b37b8ed8b4ecf3'

}

