'use strict'

base91 = require 'base91'
GitHubApi = require 'github'
redis = require 'redis'

class GitHubETag
#   constuctor: (defaults = {}) ->
#     params = 

#     @github = new GitHubApi
#       version: 

# # Load redis
# redisClient = redis.createClient config.redis_db.port, config.redis_db.host

# File = mongoose.model 'File'
# Repository = mongoose.model 'Repository'

# github = new GitHubApi
#   version: '3.0.0'
#   debug: false

# exports.get = (req, res, next) ->
#   repoQuery =
#     user_id: req.user._id
#     _id: req.param 'repo_id'

#   Repository.findOne repoQuery, (err, repo) ->
#     return next err if err
    
#     response =
#       status: 'ok'
#       repo: repo

#     res.json response

# exports.list = (req, res, next) ->
#   repoQuery =
#     user_id: req.user._id

#   Repository.find repoQuery, (err, repos) ->
#     return next err if err
    
#     response =
#       status: 'ok'
#       repos: repos

#     res.json response

# exports.listRemote = (req, res, next) ->
#   user = req.user

#   github.authenticate
#     type: 'oauth'
#     token: user.github.accessToken

#   ghRepoQuery =
#     type: 'all'
#     per_page: 100

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

# exports.getRemote = (req, res, next) ->
#   owner_name = req.param 'owner_name'
#   repo = req.param 'repo'


#   github.authenticate
#     type: 'oauth'
#     token: req.user.github.accessToken

#   ghRepoQuery =
#     user: owner_name
#     repo: repo

#   etagKey = "GH:ETAG:repos.get:#{req.user.github.accessToken}:#{JSON.stringify(ghRepoQuery)}"
#   ghReponseKey = "GH:RESPONSE:repos.get:#{req.user.github.accessToken}:#{JSON.stringify(ghRepoQuery)}"

#   redisClient.get etagKey, (err, etag) ->
#     return next err if err

#     if etag?
#       ghRepoQuery.headers =
#         "If-None-Match": etag


#   github.repos.get ghRepoQuery, (err, repo) ->
#     # TODO: Refactor this with Github API clarification
#     #   Currently, we don't know from the listRemote API if all
#     #   of the repos are active or not, so we need to run a call
#     #   against each repo
#     if err?.message?
#       if JSON.parse(err.message).message is 'Not Found'
#         response =
#           status: 'notok'
#           error: 'Not Found'
        
#         return res.json response

#     return next err if err

#     if repo.meta.status is '304 Not Modified'
#       redisClient.get ghReponseKey, (err, redisRepo91) ->
#         return next err if err

#         redisClient.expire etagKey, 60
#         redisClient.expire ghReponseKey, 60

#         redisRepo = base91.decode redisRepo91

#         repo = JSON.parse redisRepo

#         response =
#           status: 'ok'
#           repo: repo

#         res.json response
#     else

#       redisClient.set etagKey, repo.meta.etag
#       redisClient.set ghReponseKey, base91.encode(JSON.stringify(repo))

#       redisClient.expire etagKey, 60
#       redisClient.expire ghReponseKey, 60

#       response =
#         status: 'ok'
#         repo: repo

#       res.json response

# exports.getRemoteBranches = (req, res, next) ->
#   repo_id = req.param 'repo_id'

#   Repository.findOne {repo_id: repo_id}, (err, repo) ->
#     return next err if err
#     return next 'Repo not found' if !repo

#     ghBranchQuery =
#       user: repo.owner_name
#       repo: repo.name

#     github.repos.getBranches ghBranchQuery, (err, branches) ->
#       return next err if err
      
#       response =
#         status: 'ok'
#         branches: branches

#       res.json response

# exports.upsert = (req, res, next) ->
#   repo = req.param 'repo'

#   repoQuery =
#     user_id: "#{req.user._id}"
#     repo_id: "#{repo.id}"

#   upsertRepo = _.clone repoQuery
#   upsertRepo.name = repo.name
#   upsertRepo.description = repo.description
#   upsertRepo.owner_name = repo.owner.login

#   Repository.findOneAndUpdate repoQuery, upsertRepo, {upsert: true, strict: true}, (err) ->
#     return next err if err

#     response =
#       status: 'ok'
#       repo: upsertRepo

#     res.json response

# exports.update = (req, res, next) ->
#   repo = req.param 'repo'
#   repo_id = req.param 'repo_id'

#   repoQuery =
#     repo_id: "#{repo_id}"

#   updatedRepo = repo
  
#   Repository.update repoQuery, updatedRepo, {strict: true}, (err) ->
#     return next err if err

#     response =
#       status: 'ok'
#       repo: updatedRepo

#     res.json response

# exports.oldestAndUpdate = (req, res, next) ->
#   repoQuery =
#     active: true

#   repoUpdate =
#     lastUpdated: Date.now()
  
#   Repository.findOneAndUpdate(repoQuery, repoUpdate).sort('lastUpdated').exec (err, repo) ->
#     return next err if err
#     response =
#       status: 'ok'
#       repo: repo

#     res.json response

# exports.updateFilesFromRemote = (req, res, next) ->
#   _id = req.param '_id'

#   Repository.findById _id, (err, repo) ->
#     return next err if err
#     return next 'Repo not found' if !repo

#     github.authenticate
#       type: 'oauth'
#       token: req.user.github.accessToken

#     files = []

#     async.each repo.branches, (branch, eachCb) ->
#       ghTreeQuery =
#         user: repo.owner_name
#         repo: repo.name
#         sha: branch.sha
#         recursive: true

#       github.gitdata.getTree ghTreeQuery, (err, tree) ->
#         return eachCb err if err

#         async.each tree.tree, (filePath, eachTreeCb) ->
#           fileQuery =
#             repo_id: repo._id
#             path: filePath.path

#           newFile =
#             path: filePath.path
#             sha: filePath.sha
#             repo_id: repo._id
#             mode: filePath.mode
#             branch: branch.name
#             type: filePath.type

#           if filePath.type is 'blob'
#             newFile.size = filePath.size
#             if newFile.size >= 1024 * 1024
#               newFile.isLarge = true

#           files.push newFile

#           File.findOneAndUpdate fileQuery, newFile, {upsert: true}, (err) ->
#             eachTreeCb err
#         , (err) ->
#           eachCb err

#     , (err) ->
#       return next err if err

#       response =
#         status: 'ok'
#         files: files

#       res.json response

# exports.updateContentsFromRemote = (req, res, next) ->
#   repoQuery =
#     _id: req.param '_id'
#     active: true

#   Repository.findOne repoQuery, (err, repo) ->
#     return next err if err
#     return next "Active repo not found for #{req.param '_id'}" if !repo

#     fileQuery =
#       repo_id: repo._id

#     File.find fileQuery, (err, files) ->
#       return next err if err

#       github.authenticate
#         type: 'oauth'
#         token: req.user.github.accessToken

#       async.eachSeries files, (file, eachCb) ->
#         if file.type isnt 'blob' or file.isLarge is true
#           return eachCb()

#         ghContentQuery =
#           user: repo.owner_name
#           repo: repo.name
#           path: file.path
#           ref: file.branch

#         github.repos.getContent ghContentQuery, (err, content) ->
#           return eachCb err if err
#           return eachCb() if content.type isnt 'blob'

#           try
#             sourceCode = new Buffer(content.content, 'base64').toString('ascii')
#           catch e
#             console.log e
#             console.log content

#           results = Classifier.classify false, sourceCode
#           console.log "#{file.path}: #{results[0]}"

#           eachCb()