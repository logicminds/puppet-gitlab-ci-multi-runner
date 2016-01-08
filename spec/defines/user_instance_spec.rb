require 'spec_helper'
require 'shared_contexts'

describe 'gitlab_ci_multi_runner::user_instance' do
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
      #:download_url => "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64",
      #:download_dir => "/home/gitlab_ci_multi_runner",
      #:create_dest_dir => true,
      #:user => "gitlab_ci_multi_runner",
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_user('gitlab_ci_multi_runner')
      .with(
        'ensure'     => 'present',
        'managehome' => 'true',
        'shell'      => '/bin/bash'
      )
  end
  it do
    is_expected.to contain_archive('/home/gitlab_ci_multi_runner/gitlab-ci-multi-runner')
      .with(
        'cleanup' => 'false',
        'creates' => '/home/gitlab_ci_multi_runner/gitlab-ci-multi-runner',
        'ensure'  => 'present',
        'extract' => 'false',
        'notify'  => 'Exec[restart $runner_ci_binary]',
        'source'  => 'https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64'
      )
  end
  it do
    is_expected.to contain_file('/home/gitlab_ci_multi_runner/gitlab-ci-multi-runner')
      .with(
        'ensure'  => 'file',
        'group'   => 'gitlab_ci_multi_runner',
        'mode'    => '555',
        'owner'   => 'gitlab_ci_multi_runner',
        'require' => 'Archive[$runner_ci_binary]'
      )
  end
  it do
    is_expected.to contain_file('$download_dest')
      .with(
        'before'  => 'Archive[$runner_ci_binary]',
        'ensure'  => 'directory',
        'group'   => 'gitlab_ci_multi_runner',
        'owner'   => 'gitlab_ci_multi_runner',
        'require' => 'User[$user]'
      )
  end
end
