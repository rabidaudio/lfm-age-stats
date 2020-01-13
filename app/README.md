Generate static data

```
rm -r docs public/packs
RAILS_ENV=production rails assets:precompile
RAILS_ENV=production RAILS_LOG_TO_STDOUT=true RAILS_SERVE_STATIC_FILES=true rails s

yarn && rails static:generate
```
