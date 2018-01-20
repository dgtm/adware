# Adware


Find differences between local system and remote API

## Installation

* Clone this repository

* And then execute:

    `$ bundle`

* Run `rspec`

## Usage

Run `./bin/demo` to get a preview of the response from library. You can modify the array of campaigns in the file to check for more differences.

List of Campaign Objects look like
```
  [
    <Campaign id=1, external_reference="2", status="paused", ad_description="Description for campaign 12">,
    <Campaign id=2, external_reference="3", status="active", ad_description="Description for campaign 13">,
    <Campaign id=3, external_reference="1", status="active", ad_description="Description for campaign 11">
   ]
```
Currently, the campaigns are not persisted to the database.
`Adware#find_differences` returns a list of differences. To find differences with the remote API, run

`Adware.find_differences(list_of_campaigns)`

This returns an array of differences that look like:

```
[
  {
    :reference_id => "1",
    :differences => [{
      :description =>
        {:one=>"Description for campaign 14", :another=>"Description for campaign 11"}
      }]
  },
  {
    :reference_id => "5",
    :differences => [{
      :base=>["Object not found in local"]
    }]
  }
]
```
Differences with the values are stored under the corresponding key name. Differences with objects that are present in local but not in remote or vise-versa are stored inside the `:base` key


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/adware.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
