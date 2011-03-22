require 'test_helper_rails'

class BuildTest < ActiveSupport::TestCase
  include GithubApiTestHelper

  test 'building a Build from Github payload' do
    Repository.delete_all

    build = Build.create_from_github_payload(JSON.parse(GITHUB_PAYLOADS['gem-release'])).reload

    assert_equal '1', build.number
    assert_equal '9854592', build.commit
    assert_equal 'Bump to 0.0.15', build.message
    assert_equal '2010-10-27 04:32:37 UTC', build.committed_at.to_formatted_s
    assert_equal 'Sven Fuchs', build.committer_name
    assert_equal 'svenfuchs@artweb-design.de', build.committer_email
    assert_equal 'Christopher Floess', build.author_name
    assert_equal 'chris@flooose.de', build.author_email

    assert_equal 'gem-release', build.repository.name
    assert_equal 'svenfuchs', build.repository.owner_name
    assert_equal 'svenfuchs@artweb-design.de', build.repository.owner_email
    assert_equal 'svenfuchs', build.repository.owner_name
    assert_equal 'http://github.com/svenfuchs/gem-release', build.repository.url
  end

  test 'next_number' do
    repository = Factory(:repository)
    assert_equal 1, repository.builds.next_number

    repository = Factory(:repository)
    3.times { |number| Factory(:build, :repository => repository, :number => number + 1) }
    assert_equal 4, repository.builds.next_number

    repository = Factory(:repository)
    Factory(:build, :repository => repository, :number => '3.1')
    assert_equal 4, repository.builds.next_number
  end
end
