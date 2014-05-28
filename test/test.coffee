GitHubETag = require '../src/index'
redis = require 'redis'
should = require 'should'

GitHubApi = require 'github'

describe 'GitHubETag', ->
  redisClient = {}
  beforeEach ->
    redisClient = redis.createClient()

  it 'should connect to redis', (done) ->
    redisClient.keys '*', (err, response) ->
      should.not.exist err

      done()

  it 'should get public information from github', (done) ->
    github = new GitHubETag
      version: '3.0.0'
      redis:
        port: '6379'
        host: '127.0.0.1'

    console.log github

    # repoQuery =
    #   user: 'shamoons'
    #   repo: 'github-redis-etag'

    # github.repos.get repoQuery, (err, repo) ->
    #   should.not.exist err
    #   repo.id.should.eql '20040151'

    #   done()

    # console.log new GitHubETag()
    # console.log github.authenticate()
      # done()

  it 'should use an oauth to get information from github', (done) ->
    # This test does not have an oauth token in here
    #   If you want this test to succeed, you need to put in
    #   a token
    done()


  it 'should save data to redis after getting from github', (done) ->
    done()