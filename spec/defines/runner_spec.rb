require 'spec_helper'
require 'shared_contexts'

describe 'gitlab_ci_multi_runner::runner' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:title) { 'XXreplace_meXX' }
  
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:gitlab_ci_url => undef,
      #:tags => undef,
      #:token => undef,
      #:env => undef,
      #:executor => undef,
      #:docker_image => undef,
      #:docker_privileged => undef,
      #:docker_mysql => undef,
      #:docker_postgres => undef,
      #:docker_redis => undef,
      #:docker_mongo => undef,
      #:docker_allowed_images => undef,
      #:docker_allowed_services => undef,
      #:parallels_vm => undef,
      #:ssh_host => undef,
      #:ssh_port => undef,
      #:ssh_user => undef,
      #:ssh_password => undef,
      #:require => [Class["gitlab_ci_multi_runner"]],
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_exec('Register-XXreplace_meXX')
      .with(
        'command'  => 'gitlab-ci-multi-runner register --non-interactive $gitlab_ci_url_opt $description_opt $tags_opt $token_opt $env_opts $executor_opt $docker_image_opt $docker_privileged_opt $docker_mysql_opt $docker_postgres_opt $docker_redis_opt $docker_mongo_opt $docker_allowed_images_opt $docker_allowed_services_opt $parallels_vm_opt $ssh_host_opt $ssh_port_opt $ssh_user_opt $ssh_password_opt',
        'cwd'      => '/home/gitlab_ci_multi_runner',
        'onlyif'   => '! grep shellquote($name) $::gitlab_ci_multi_runner::version ? { /^0\\.[0-4]\\..*/ => $home_path/config.toml, default => $home_path/.gitlab-runner/config.toml }',
        'provider' => 'shell',
        'require'  => '[Class[gitlab_ci_multi_runner]]',
        'user'     => 'gitlab_ci_multi_runner'
      )
  end
end
