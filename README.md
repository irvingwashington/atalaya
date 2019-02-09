# Atalaya
A watchtower Ruby rack application.
This gem provides a Rack-application that offers a snapshot insight into the state of the mother-application Ruby process.

### Visors
Atalaya features several visors:
 - VM
 - Process
 - Rails
 - Puma

### Example output

```JSON
{
     "process" : {
      "process_id" : 12108,
      "threads" : {
         "backtraces" : [
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/cluster.rb:306:in `join'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/cluster.rb:254:in `select'",
            "/app/shared/bundle/ruby/2.6.0/gems/activerecord-5.2.2/lib/active_record/connection_adapters/abstract/connection_pool.rb:301:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/cluster.rb:291:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/thread_pool.rb:119:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/thread_pool.rb:119:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/thread_pool.rb:119:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/bundler/gems/atalaya-0eab2b5556fa/lib/atalaya/visors/process.rb:25:in `backtrace'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/reactor.rb:126:in `select'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/thread_pool.rb:283:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/thread_pool.rb:254:in `sleep'",
            "/app/shared/bundle/ruby/2.6.0/gems/puma-3.12.0/lib/puma/server.rb:384:in `select'",
            "/app/shared/bundle/ruby/2.6.0/gems/newrelic_rpm-6.0.0.351/lib/new_relic/agent/event_loop.rb:118:in `select'"
         ],
         "statuses" : [
            "sleep",
            "sleep",
            "sleep",
            "sleep",
            "sleep",
            "sleep",
            "sleep",
            "run",
            "sleep",
            "sleep",
            "sleep",
            "sleep",
            "sleep"
         ],
         "count" : 13
      }
   },
   "puma" : {
      "server" : {
         "mode" : "cluster",
         "workers" : 2
      }
   },
   "rails" : {
      "action_mailer" : null,
      "action_controller" : null,
      "action_view" : null,
      "active_record" : {
         "prepared_statements_count" : [
            4
         ],
         "pool_size" : 5,
         "prepared_statements" : [
            {
               "\"$user\", public-SELECT  \"specifications\".* FROM \"specifications\" WHERE \"specifications\".\"id\" = $1 LIMIT $2" : "a4",
               "\"$user\", public-SELECT  \"makes\".* FROM \"makes\" WHERE \"makes\".\"id\" = $1 LIMIT $2" : "a2",
               "\"$user\", public-SELECT  \"models\".* FROM \"models\" WHERE \"models\".\"id\" = $1 LIMIT $2" : "a3",
               "\"$user\", public-SELECT  \"motorcycles\".* FROM \"motorcycles\" WHERE \"motorcycles\".\"fake_id\" = $1 LIMIT $2" : "a1"
            }
         ],
         "active_connections_count" : 1
      },
      "cache": null
   },
   "vm" : {
      "object_space" : {
         "T_STRING" : 78621,
         "T_RATIONAL" : 790,
         "T_COMPLEX" : 1,
         "T_DATA" : 5608,
         "T_STRUCT" : 904,
         "T_CLASS" : 7468,
         "T_OBJECT" : 7477,
         "T_MATCH" : 60,
         "TOTAL" : 287656,
         "T_SYMBOL" : 665,
         "T_IMEMO" : 86961,
         "T_MODULE" : 1066,
         "T_REGEXP" : 1898,
         "T_ICLASS" : 1845,
         "T_HASH" : 4109,
         "T_FLOAT" : 2282,
         "T_FILE" : 27,
         "T_ARRAY" : 13057,
         "T_BIGNUM" : 731,
         "FREE" : 74086
      },
      "gc_stat" : {
         "heap_tomb_pages" : 0,
         "heap_available_slots" : 287656,
         "old_objects_limit" : 405568,
         "remembered_wb_unprotected_objects_limit" : 5810,
         "total_allocated_objects" : 2033068,
         "heap_allocatable_pages" : 0,
         "total_freed_pages" : 0,
         "malloc_increase_bytes_limit" : 16777216,
         "total_allocated_pages" : 352,
         "heap_marked_slots" : 208589,
         "total_freed_objects" : 1819498,
         "malloc_increase_bytes" : 197020,
         "heap_eden_pages" : 352,
         "heap_free_slots" : 74086,
         "heap_allocated_pages" : 352,
         "heap_final_slots" : 0,
         "heap_live_slots" : 213570,
         "old_objects" : 202784,
         "heap_sorted_length" : 352,
         "oldmalloc_increase_bytes_limit" : 16777216,
         "remembered_wb_unprotected_objects" : 2905,
         "major_gc_count" : 11,
         "oldmalloc_increase_bytes" : 3257268,
         "count" : 63,
         "minor_gc_count" : 52
      }
   }
}
```

### Installation
You'll need to add atalaya to your Gemfile
```ruby
# Use most recent version
gem 'atalaya', git: 'https://github.com/irvingwashington/atalaya.git'

# Or use the stable version from RubyGems
gem 'atalaya'
```
Run `bundle install`.

In your Rails app, add the rack application entry.
```
Rails.application.routes.draw do
  # ...
  match '/atalaya.json', to: Atalaya::App.new, via: :get
  # ...
end
```
However, serving this information publicly is not a good idea. You should wrap the app with some
form of authentication.
You can use a custom routing constraint class if your app doesn't have any other form of authentication.

```ruby
# lib/constraints/authenticated_call.rb
module Constraints
  class AuthenticatedCall
    def self.matches?(request)
      if ActionController::HttpAuthentication::Basic.has_basic_credentials?(request)
        credentials = ActionController::HttpAuthentication::Basic.decode_credentials(request)
        login, password = credentials.split(':')

        login == 'foo' && password == 'bar'
    end
    end
  end
end

# config/routes.rb
require Rails.root.join('lib', 'constraints', 'authenticated_call')

Rails.applcation.routes.draw do
  constraints Constraints::AuthenticatedCall do
    match '/atalaya.json', to: Atalaya::App.new, via: :get
  end
end
```
