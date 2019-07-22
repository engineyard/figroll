# figroll #

Figroll is a somewhat simple gem to ease your way into the use of environment variables for configuration. It is not tied to any specific framework, so you can use it just about anywhere.

Fetching information via Figroll works roughly like this:

* If `ENV` contains the variable that you want to use, Figroll provides the data from `ENV`
* If the varible you want to use is not in `ENV`, Figroll falls back to data provided in a YAML config file.
* If the variable you want to use is missing from both `ENV` and the config file, Figroll raises an error.

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'figroll'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install figroll

## Usage ##

There are two aspects of usage with Figroll: Configuration and Consumption

### Configuration ###

To configure `Figroll` and initialize it for use, you pass a config file location to `Figroll.configure`, preferably rather early in your application's startup process. For example, in a Rails 2 application, I generally make the `configure` call towards the top of  `config/environment.rb`:

```ruby
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'figroll'

Rails::Initializer.run do |config|
  Figroll.configure(File.join(File.dirname(__FILE__), 'figroll.yml'))

  # ...
end
```

#### Config File ####

The Figroll configuration file is just a YAML file with specific information. Here's an example config file that shows off all of the configuration features:

```yaml
# The variables listed in "required" *must* be present either as incoming
# environment variables (`ENV`) or via the "environments" section below.
required:
  - REQUIRED_VARIABLE_1
  - REQUIRED_VARIABLE_2

# The entries in the "environments" section are tied to the `FIGROLL_ENV`
# environment variable. Each of these is in turn a list of default values for
# that specific environment to use in case those variables are not set in the
# execution environment.
environments:
  development:
    REQUIRED_VARIABLE_1: dev 1
    REQUIRED_VARIABLE_2: dev 2
  staging:
    REQUIRED_VARIABLE_1: staging 1
    REQUIRED_VARIABLE_2: staging 2
```

***Best Practice: Use Figroll in production, but do not store a "production" environment in your Figroll config file. Instead, define the variables in production's execution environment.***

#### Required Variables ####

The "required" section of the config file is used to list out environment variables without which your application absolutely cannot run. A good example of such a beast is `DATABASE_URL` for the great majority of Rails apps, but we suggest making all or most of your variables required.

If a variable listed in this section lacks a value at the time that `Figroll.configure` is run, the configure call raises a runtime error to reflect that missing variable. As mentioned above, it's a good idea to configure Figroll early in your application's boot process, and the specific reasoning behind that is to ensure that if there is missing configuration data, app booting fails as early as possible so you can fix it more quickly.

The "required" section, however, is optional. To that end, if you leave it out, you may end up seeing fun surprises later in your application deployment's lifetime. My go-to example for this is that everything about your app may run seemingly well, but a missing payment gateway API key variable might cause checkouts to inexplicably fail.

#### Variable Precedence ####

The "environments" section of the Figroll config file allows one to provide default values for specific variables in case they don't appear in the execution environment.

Using the above config file as an example, let's assume that `FIGROLL_ENV` is set to `staging`.

If you pass this file to `Figroll.configure` with no other information in your environment, `Figroll.fetch(:required_variable_1)` will return `staging 1`.

On the other hand, if `FIGROLL_ENV` is set to `staging` and `REQUIRED_VARIABLE_1` is set to `algebraic`" when you `Figroll.configure`, `Figroll.fetch(:required_variable)` will return `algebraic`.

***tl;dr - Values from the execution environment have precedence over values from the Figroll config file.***

### Consumption ###

One consumes values from Figroll via `Figroll.fetch`, which takes either a symbol or a string as the variable name to fetch. One important consideration is that variable names in Figroll are not case-sensitive. That is, `var1` is the same as both `Var1` and `VAR1`.

If you should call `Figroll.fetch` for a variable that was not known when `Figroll.configure` was called, a `RuntimeError` is raised. Otherwise, if we can resolve the requested variable name to a known variable, the value of that variable is returned.

#### Consistency ####

While it's easy and reasonable to think of Figroll as a proxy to `ENV`, that's not entirely accurate. Figroll only considers variables and values that are known (either in the execution environment or in the config file) at the point in time when `Figroll.configure` is called.

**That is, changing an environment variable while an app is running does not affect what is returned when you `Figroll.fetch` that variable.**

To that end, it would be best to avoid retrieving information directly from `ENV`.

## Similar Projects ##

Figroll isn't an entirely new idea at all. In this case, we're standing on the shoulders of these giants:

* [figaro](https://github.com/laserlemon/figaro) is the most direct inspiration for this library, to the effect that we borrowed most of its features. The big difference is that Figroll does not automagically inject itself into your application, as it is meant to serve more frameworks than just Rails 3+. Additionally, `figaro` is a proper `ENV` proxy, so it's possible to use it somewhat interchangeably with `ENV`, and it also allows for env var mutability.
* [dotenv](https://github.com/bkeepers/dotenv) is somewhat the grandfather of Figroll. The primary issue with it that made us want to roll our own library is that it's specifically not advised to use dotenv for production, whereas we want to do exactly that without much hoop jumping.
* [envyable](https://github.com/philnash/envyable) is another gem that works quite a lot like Figroll. The primary difference here is that of variable precedence ... it appears that envyable favors values from its config file rather than incoming variables from the execution environment.

## History ##

* 1.0.0 - Initial public release
* 0.0.2 - Clean error message
* 0.0.1 - A prerelease for internal tire kicking

## License ##

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
