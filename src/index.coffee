'use strict'

_ = require 'lodash'
base91 = require 'base91'
GitHubApi = require 'github'
redis = require 'redis'
util = require 'util'

class GitHubETag extends GitHubApi
  repos = {}

  constructor: (defaults = {}) ->
    @github = new GitHubApi
      version: '3.0.0' || defaults.version?
      debug: false || defaults.false?
      protocol: 'http' || defaults.protocol?
      host: null || defaults.host?
      pathPrefix: '' || defaults.pathPrefix?
      timeout: null || defaults.timeout?

    @redisClient = redis.createClient ('6379' || defaults.redis?.port?), ('127.0.0.1' || defaults.redis?.host?)

    githubObjects = ['events', 'gists', 'gitdata', 'issues', 'markdown', 'orgs', 'pullRequests', 'repos', 'search', 'statuses', 'user']

    # _.each githubObjects, (object) =>
    #   @object = {}

    #   _.each _.keys(@github[object]), (key) =>
    #     fn = @github[object][key]
    #     @object[key] = @github[object][key]
    #     console.log "#{object}:#{key}"

        # fn.apply @githu


    # _.each githubObjects, (object) =>
    #   @[object] = {}
    #   _.each _.keys(@github[object]), (key) =>
    #     console.log "#{object}:#{key}"
    #     fn = @github[object][key]

    #     @[object][key] = (args, callback) =>
    #       eTagKey = "GitHubETag::ETAG::#{object}::#{key}::#{JSON.stringify(args)}"
    #       ghReponseKey = "GitHubETag::RESPONSE::#{object}::#{key}::#{JSON.stringify(args)}"

    #       @redisClient.get eTagKey, (err, etag) =>
    #         return callback err if err

    #         if etag?
    #           args.headers =
    #             "If-None-Match": etag

    #         console.log fn.toString()

    #         fn.call @, args, (err, response) ->
    #           console.log err
    #           console.log response



#   etagKey = "GH:ETAG:repos.getAll:#{user.github.accessToken}:#{JSON.stringify(ghRepoQuery)}"
#   ghReponseKey = "GH:RESPONSE:repos.getAll:#{user.github.accessToken}:#{JSON.stringify(ghRepoQuery)}"

#   redisClient.get etagKey, (err, etag) ->
#     return next err if err

#     if etag?
#       ghRepoQuery.headers =
#         "If-None-Match": etag

#     github.repos.getAll ghRepoQuery, (err, repos) ->
#       return next err if err

#       if repos.meta.status is '304 Not Modified'
#         redisClient.get ghReponseKey, (err, redisRepos91) ->
#           return next err if err

#           redisClient.expire etagKey, 60
#           redisClient.expire ghReponseKey, 60

#           redisRepos = base91.decode redisRepos91

#           repos = JSON.parse redisRepos

#           response =
#             status: 'ok'
#             repos: repos

#           res.json response
#       else

#         redisClient.set etagKey, repos.meta.etag
#         redisClient.set ghReponseKey, base91.encode(JSON.stringify(repos))

#         redisClient.expire etagKey, 60
#         redisClient.expire ghReponseKey, 60

#         response =
#           status: 'ok'
#           repos: repos

#         res.json response


module.exports = GitHubETag