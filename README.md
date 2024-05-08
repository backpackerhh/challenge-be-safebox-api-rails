# Safebox API Challenge - Rails way

## Up and running

You will need [Docker](https://docs.docker.com/engine/install/) to run this project.

Go to the directory where the project is stored:

```bash
cd <path/to/project>
```

Build and start the project:

```bash
make start
```

Create databases:

```bash
make db-create
```

Check the `config/database.yml` file exists in case of failure. If does not exist, run following command:

```bash
cp config/database.yml{.sample,}
```

And try again creating the database.

Run migrations (default environment is `development`):

```bash
$ make db-migrate
$ make db-migrate APP_ENV=<environment>
```

Run test suite:

```bash
$ make test
```

Run API tests only:

```bash
$ make test-api
```

Run linter:

```bash
$ make lint
```

Take a look at `Makefile` to see other commands available.

## Code

The code in this challenge has been inspired by [Upgrow](https://github.com/backpackerhh/upgrow-docs) (Shopify) and my previous experience in other companies.

**Disclaimer: This approach follows a more classical approach in Rails application, although bear in mind that some logic could be extracted from the models to more specilized objects. In any case, the organization of the code will depend on the agreements with the rest of the team.**

These changes are based on the previous work present on the [ddd-hexagonal](https://github.com/backpackerhh/challenge-be-safebox-api-rails/tree/ddd-hexagonal) branch, so the relevant information is included in those commits.

### Technical choices

#### Programming language

[Ruby 3.3.0](https://www.ruby-lang.org/en/news/2023/12/25/ruby-3-3-0-released/)

#### Framework

[Rails 7.1.3.2](https://rubyonrails.org/2024/2/21/Rails-Versions-6-1-7-7-7-0-8-1-and-7-1-3-2-have-been-released)

#### Database

[PostgreSQL 16](https://www.postgresql.org/docs/release/16.2/)

#### Containers

[Docker 26](https://docs.docker.com/engine/release-notes/26.0/#2602) + [docker compose 2](https://docs.docker.com/compose/release-notes/#2270)

#### Dependencies

[JSON:API Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) to serialize objects following [JSON:API](https://jsonapi.org/) specification.

[RSwag](https://github.com/rswag/rswag) to test and generate Swagger/OpenAPI documentation.

[bcrypt](https://github.com/bcrypt-ruby/bcrypt-ruby) to encrypt passwords.

[dry-rails](https://dry-rb.org/gems/dry-rails) and [dry-struct](https://dry-rb.org/gems/dry-struct) from the great [dry-rb](https://dry-rb.org/) project.

Check the `Gemfile` for more dependencies for development and test environments.

I've tried to keep external dependencies to a minimum. Every time a new dependency has been added, details about it were included in the relevant commit.

### Design

The structure of the code follows the classical approach in a Rails application:

* Everything is placed in `app` directory.
* Every controller includes multiple actions.
* Every model has multiple responsibilities: associations, validations, domain logic, alias attributes...

### Decisions

* The API follows the JSON:API specification.
* The API implements the [level 3 of the Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html#level3), including links in the response.
* Inherited from the DDD approach:
  * Database tables include the name of the bounded context as prefix (e.g. safeboxes_safeboxes).
  * UUIDs are always generated for the application instead of delegating that generation to the database.
* UUID are used instead of regular IDs (integer, auto increment).
* Most files include their type in the filename: `SafeboxesController`, `DuplicatedRecordError`, `SafeboxSerializer`, ... As with most Rails application, models are an exception.
* New records are created only after params are validated using ActiveRecord.
* An encrypted password (Base64) is provided in a header to the open safebox endpoint.
* The token generated when the safebox is open is then provided in a header to the endpoints in charge of listing and adding items to the safebox.
* Although not strictly necessary, pagination and sorting have been implemented.
* All errors returned by the API follow the same structure, although some fields are optional.
* Some RuboCop cops are just disabled for certain files:
  * Although it'd be a team decision, personally I prefer to explicitly disable cops in `.rubocop.yml` file, instead of doing it inline in every file.
  * Usually I've worked with single quotes, but here I chose double quotes instead.
  * I avoid conditional modifiers at the end of the lines. If there is a condition, I prefer to see it upfront.
  * I completely avoid the use of `unless` in Ruby, whenever possible. IMHO, it adds a cognitive load in most cases.

## Testing

I have tested everything with a mix of unit and integration tests, adding acceptance tests for every endpoint.

I embrace [WET tests](https://thoughtbot.com/blog/the-case-for-wet-tests).

#### Factories

[FactoryBot](https://github.com/thoughtbot/factory_bot) is used to define every entity factory and some attributes of those factories internally use [Faker](https://github.com/faker-ruby/faker) to define a default value.

## Possible improvements

* Consider extracting validations, associations and business logic from models.
* Consider moving existing files inside `Safeboxes` module.
* Consider removing some duplication from the code.
* Tackle certain cyclomatic complexity ignored in some files, where RuboCop was silenced.
* Remove unnecessary files from version control and/or the Docker image.
* Add logging and error handling in certain parts of the code that are now missing.
* Add some kind of monitoring tool, such as Prometheus or Datadog.
* Add some kind of CI/CD pipeline, such as GitHub Actions, GitLab or Jenkins.
