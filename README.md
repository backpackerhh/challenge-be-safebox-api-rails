# Safebox API Challenge - DDD & Hexagonal Implementation

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

The code in this challenge has been highly inspired by [CodelyTV](https://codely.com/) and slightly inspired by [Upgrow](https://github.com/backpackerhh/upgrow-docs) (Shopify).

**Disclaimer: I spent a few months deepen my knowledge of DDD and Hexagonal Architecture with CodelyTV courses and just wanted to apply their teachings to Ruby, to see to what extent it was feasible to do it in this language. Honestly, I would not apply this approach to a real Rails application, because the team would have to spend most of the time fighting the framework instead of taking advantage of the functionalities it provides. IMHO, a framework as Hanami could be a better fit for this approach.**

You'll find lots of details about changes made in most of the commits, including links to relevant information.

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

#### Domain-Driven Design (DDD)

The **strategical design** can't be properly applied here without access to *domain experts*.

That means that there is no *ubiquitous language* defined as such, so I've used the names specified in the instructions.

The bounded contexts created are placed in `contexts` directory:

* **safeboxes** (namespace **SafeboxesContext**): includes all the logic specific to safeboxes.
* **shared** (namespace **SharedContext**): includes all the logic that could be reused among multiple bounded contexts.

```
├── contexts
│   ├── safeboxes_context
│   |   ├── safeboxes
│   |   │   ├── ...
│   └── shared_context
│       ├── ...
```

The entrypoints, in this case only controllers, are placed in `apps` directory:

```
└── apps
    └── safe_ish
        └── safeboxes
            └── api
                └── ...
```

I've applied the **tactical design** in this challenge making use of the following building blocks:

* **Entities** and **value objects** to define *aggregates*, with their respective *aggregate root*.
* **Domain services** to interact with an inner entity included in an aggregate root.
* **Factories** to encapsulate the creation of entities both in production and test code.
* **Application services** to represent *use cases*.
* **Repositories** to interact with the database.

No **domain events** have been implemented at this point.

#### Hexagonal Architecture (Ports and Adapters)

The code is organized using a *layered architecture*, where the outer layers can use code from the inner layers, but not the other way around.

In addition, the code is structured using **vertical slicing**, where each module contains a directory per layer.

The benefit of this approach is a code better organized, less indirection and, in case of wanting to promote a module to a bounded context later on, the code will be easier to extract.

The list of objects in every layer in this challenge is as follows:

* **infrastructure**: inputs, requests, links, repositories (adapters), serializers, records
* **application**: application services (use cases)
* **domain**: entities, value objects, repositories (ports), domain services, test factories, errors

### Decisions

* Contexts and entrypoints are placed in different directories (approach suggested by CodelyTV).
* Controllers include a single action and their name are more semantic that default Rails controllers.
* The API follows the JSON:API specification.
* The API implements the [level 3 of the Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html#level3), including links in the response.
* Database tables include the name of the bounded context as prefix (e.g. safeboxes_safeboxes).
* UUID are used instead of regular IDs (integer, auto increment).
* UUIDs are always generated for the application instead of delegating that generation to the database.
* Every file include its type in the filename: `CreateSafeboxUseCase`, `SafeboxEntity`, `SafeboxIdValueObject`, ...
* Constructor is private for aggregate roots, so `.from_primitives` factory method must be used instead.
* Every attribute is represented by a value object, with the potential tradeoff of having too many files when the application grows.
* Value objects only include `value` attribute.
* Records (models in the classical MVC pattern) only define the table name and stuff related to the ActiveRecord model (no validations, associations nor callbacks).
* New records are created only after params are validated using JSON Schema.
* An encrypted password (Base64) is provided in a header to the open safebox endpoint.
* The token generated when the safebox is open is then provided in a header to the endpoints in charge of listing and adding items to the safebox.
* Although not strictly necessary, pagination and sorting have been implemented.
* Uses dry and some of the gems of its ecosystem to enable auto dependency injection in Rails.
* All errors returned by the API follow the same structure, although some fields are optional.
* Some RuboCop cops are just disabled for certain files:
  * Although it'd be a team decision, personally I prefer to explicitly disable cops in `.rubocop.yml` file, instead of doing it inline in every file.
  * Usually I've worked with single quotes, but here I chose double quotes instead.
  * I avoid conditional modifiers at the end of the lines. If there is a condition, I prefer to see it upfront.
  * I completely avoid the use of `unless` in Ruby, whenever possible. IMHO, it adds a cognitive load in most cases.
* Although I'm not implementing CQRS, I avoid commands (create, update...) returning any value.
* On purpose tests are kept to a minimum:
  * The goal was having great confidence in the test suite, avoiding changes in tests as much as possible when some implementation detail changed.
  * Another goal was avoiding duplicate tests where the same functionality is tested again and again in different kind of tests.

## Testing

In this challenge I've followed as much as possible an **Outside-In Test-Driven Development** approach. It leverages the same *red, green, refactor* steps than TDD, but starting from the outside of the application and going inwards.

In short, the process is something like this:

* Add an acceptance test, that should be failing for the expected reason, e.g. a record not being created.
* Add a unit test, that should be failing for the expected reason. Use mocks where needed.
* Add code to make the unit test pass.
* Follow the TDD cycle as many times as needed.
* Add integration tests for implementations of repositories.
* Add code to make the integration tests pass.
* The acceptance test should be passing now.

I must say that I usually would have tested everything with a mix of unit and integration tests, maybe adding an acceptance test here and there, but I think this approach works perfectly as well.

I embrace [WET tests](https://thoughtbot.com/blog/the-case-for-wet-tests).

#### Acceptance tests

Request specs that are testing an entire entry point in the application (controller action).

These are the tests that give you more confidence about the code, but at the same time are the slowest tests.

**Black box testing** is applied, so any small change in the code does not have to imply a change in the tests as well.

#### Integration tests

Focused here in repositories.

Checks every edge case that comes to mind, such as returning an empty collection, a collection with expected results, creation with and without errors, etc.

#### Unit tests

The main difference here is what it's considered a unit.

Probably most people would consider a class or a method is a unit, but in this case, following once again the teachings of CodelyTV, the use case is the one that is considered a unit.

Any collaborator object is mocked, such as the repository.

Checks every edge case that comes to mind, such as creation with and without valid attributes, exceptions raised for every attribute, etc.

#### Factories

All factories are encapsulated in domain objects placed in `spec/contexts/safeboxes_context/safeboxes/domain`, following a similar structure than production objects in `contexts/safeboxes_context/safeboxes/domain`.

No associations have been added in factories, so all created records are explicitly defined in every spec.

[FactoryBot](https://github.com/thoughtbot/factory_bot) is used to define every entity factory and some attributes of those factories internally use [Faker](https://github.com/faker-ruby/faker) to define a default value.

## Possible improvements

* Define the approach for the *strategical design* with domain experts.
* Consider organizing files by type within each layer in every bounded context.
* Consider removing some duplication from the code.
* Consider using another framework if you are convinced that this is the approach the application requires.
* Tackle certain cyclomatic complexity ignored in some files, where RuboCop was silenced.
* Remove unnecessary files from version control and/or the Docker image.
* Add logging and error handling in certain parts of the code that are now missing.
* Add some kind of monitoring tool, such as Prometheus or Datadog.
* Add some kind of CI/CD pipeline, such as GitHub Actions, GitLab or Jenkins.
