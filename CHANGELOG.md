# Changelog for Cldr_Units v3.1.0

This is the changelog for Cldr_units v3.1.0 released on May 18th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Add `Cldr.Unit.to_iolist/3` and `Cldr.Unit.to_iolist!/3` to return the formatted unit as an iolist rather than a string. This allows for formatting the number and the unit name differently. It also allows some efficiency in inserting formatted content into a Phoenix workflow since it handles iolists efficiently.

### Bug Fixes

* Fix resolving translatable unit names from strings

* Fix converting translatable units that have a "per" conversion

# Changelog for Cldr_Units v3.0.1

This is the changelog for Cldr_units v3.0.1 released on May 15th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Corrects unit creation when the unit itself is directly translatable (like `:kilowatt_hour`) but there is no explicit conversion, just an implicit calculated conversion. Thanks to @syfgkjasdkn.

# Changelog for Cldr_Units v3.0.0

This is the changelog for Cldr_units v3.0.0 released on May 4th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Summary

* New unit creation including rational numbers

* Base unit calculation

* New unit preferences

* New conversion engine

### Breaking changes

* `Cldr.Unit.new/2` is now `Cldr.Unit/{2, 3}` and it returns a standard `{:ok, unit}` tuple on success. Use `Cldr.Unit.new!/{2,3}` if you want to retain the previous behaviour.

* Removed `Cldr.Unit.unit_tree/0`

* Removed `Cldr.Unit.units/1`

* Removed `Cldr.Unit.compatible_units/2`

* Removed `Cldr.Unit.best_match/1`

* Removed `Cldr.Unit.jaro_match/1`

* Removed `Cldr.Unit.unit_category_map/0` (replaced with `Cldr.Unit.base_unit_category_map/0`)

### Deprecations

* Deprecate `Cldr.Unit.unit_categories/0` in favour of `Cldr.Unit.known_unit_categories/0` to be consistent across CLDR.

### Enhancements

* Incorporate CLDR's unit conversion data into the new conversion engine

* Unit values may now be rational numbers.  Conversion data and the results of conversions are executed and retained as rationals. New units can be created with integer, float, Decimal or rational numbers. Conversion to floats is done only when the unit is output via `Cldr.Unit.to_string/3` or explicitly through the new function `Cldr.Unit.ratio_to_float/1`

* Add an option `:usage` to `Cldr.Unit.new/{2,3}`. This defines an expected usage for a given unit that will be applied during localization. The default is `:default`. See `Cldr.Unit.unit_category_map/0` for what usage is defined for a unit category.

* Add `Cldr.Unit.known_measurement_sytems/0` to return the known measurement systems

* Add `Cldr.Unit.Conversion.preferred_units/3` that returns a list of preferred units for a given unit. This makes it straight forward to take a unit and convert it to the units preferred by the user for a given unit type, locale and use case.

* Add `Cldr.Unit.base_category_map/0` that maps base units to their unit categories. For example, map `mile_per_hour` to `:speed` or `kilogram_square_meter_per_cubic_second_ampere` to `:voltage`. Base units are derived from a unit name and are not normally the concern of the consumer of `ex_cldr_units`.

# Changelog for Cldr_Units v2.8.1

This is the changelog for Cldr_units v2.8.1 released on April 25th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Updates data management to be compatible with data from both both CLDR 36 (ex_cldr 2.13) and CLDR 37 (ex_cldr 2.14)

# Changelog for Cldr_Units v2.8.0

This is the changelog for Cldr_units v2.8.0 released on January 27th, 2020.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Support the new `Enum.sort/2` in Elixir 1.10. The function `Cldr.Math.cmp/2` is deprecated in favour of `Cldr.Math.compare/2` that has the same function signature and returns the same result that is compatible with Elixir 1.10.

* Adds `Cldr.Unit.compare/2` that is required for `Enum.sort/2` to work as expected with units.

As an example:
```
iex> alias Cldr.Unit                                                                             Cldr.Unit

iex> unit_list = [Unit.new(:millimeter, 100), Unit.new(:centimeter, 100), Unit.new(:meter, 100), Unit.new(:kilometer, 100)]
[#Unit<:millimeter, 100>, #Unit<:centimeter, 100>, #Unit<:meter, 100>,
 #Unit<:kilometer, 100>]

iex> Enum.sort unit_list, Cldr.Unit
[#Unit<:millimeter, 100>, #Unit<:centimeter, 100>, #Unit<:meter, 100>,
 #Unit<:kilometer, 100>]

iex> Enum.sort unit_list, {:desc, Cldr.Unit}
[#Unit<:kilometer, 100>, #Unit<:meter, 100>, #Unit<:centimeter, 100>,
 #Unit<:millimeter, 100>]

iex> Enum.sort unit_list, {:asc, Cldr.Unit}
[#Unit<:millimeter, 100>, #Unit<:centimeter, 100>, #Unit<:meter, 100>,
 #Unit<:kilometer, 100>]
```

# Changelog for Cldr_Units v2.7.0

This is the changelog for Cldr_units v2.7.0 released on October 10th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Update [ex_cldr](https://github.com/elixir-cldr/cldr) to version `2.11.0` which encapsulates [CLDR](https://cldr.unicode.org) version `36.0.0` data.

* Update minimum Elixir version to `1.6`

* Adds conversion for `newton meter`, `dalton`, `solar luminosity`, `pound foot`, `bar`, `newton`, `electron volt`, `barrel`, `dunam`, `decade`, `mole`, `pound force`, `megapascal`, `pascal`, `kilopascal`, `solar radius`, `therm US`, `British thermal unit`, `earth mass`.

# Changelog for Cldr_Units v2.6.1

This is the changelog for Cldr_units v2.6.1 released on August 31st, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Fix `Cldr.Unit.to_string/3` to ensure that `{:ok, string}` is returned when formatting a list of units

# Changelog for Cldr_Units v2.6.0

This is the changelog for Cldr_units v2.6.0 released on August 25th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Add `Cldr.Unit.localize/3` to support converting a given unit into units that are familiar to a given territory. For example, given a unit of `#Unit<2, :meter>` is would normally be expected to show this as `[#Unit<:foot, 5>, #Unit<:inch, 11>]`. The data to support these conversions is returned by `Cldr.Unit.unit_preferences/0`. An example:

```elixir
  iex> height = Cldr.Unit.new(1.8, :meter)
  iex> Cldr.Unit.localize height, :person, territory: :US, style: :informal
  [#Unit<:foot, 5>, #Unit<:inch, 11>]
```

  * Note that conversion is dependent on context. The context above is `:person` reflecting that we are referring to the height of a person. For units of `length` category, the other contexts available are `:rainfall`, `:snowfall`, `:vehicle`, `:visibility` and `:road`. Using the above example with the context of `:rainfall` we see

```elixir
  iex> Cldr.Unit.localize height, :rainfall, territory: :US
  [#Unit<:inch, 71>]
```

* Adds a `:per` option to `Cldr.Unit.to_string/3`. This option leverages the `per` formatting style to allow compound units to be printed.  For example, assume want to emit a string which represents "kilograms per second". There is no such unit defined in CLDR (or perhaps anywhere!). But if we define the unit `unit = Cldr.Unit.new(:kilogram, 20)` we can then execute `Cldr.Unit.to_string(unit, per: :second)`.  Each locale defines a specific way to format such a compount unit.  Usually it will return something like `20 kilograms/second`

* Adds `Cldr.Unit.unit_preferences/0` to map units into a territory preference alternative unit

* Adds `Cldr.Unit.measurement_systems/0` that identifies the unit system in use for a territory

* Adds `Cldr.Unit.measurement_system_for/1` that returns the measurement system in use for a given territory.  The result will be one of `:metric`, `:US` or `:UK`.

### Deprecation

* Add `Cldr.Unit.unit_category/1` and deprecate `Cldr.Unit.unit_type/1` in order to be consistent with the nomenclature of CLDR

# Changelog for Cldr_Units v2.5.3

This is the changelog for Cldr_units v2.5.3 released on August 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Fix `@spec` for `Cldr.Unit.to_string/3` and `Cldr.Unit.to_string!/3`

# Changelog for Cldr_Units v2.5.2

This is the changelog for Cldr_units v2.5.2 released on August 21st, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Replace `Cldr.get_current_locale/0` with `Cldr.get_locale/0`in docs

* Fix dialyzer warnings

# Changelog for Cldr_Units v2.5.1

This is the changelog for Cldr_units v2.5.1 released on June 18th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Standardize the development cldr backend as `MyApp.Cldr` which makes for more understandable and readable examples and doc tests

* `Cldr.Unit.to_string/3` now allows for the `backend` parameter to default to `Cldr.default_backend/0`

# Changelog for Cldr_Units v2.5.0

This is the changelog for Cldr_units v2.5.0 released on March 28th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Updates to [CLDR version 35.0.0](http://cldr.unicode.org/index/downloads/cldr-35) released on March 27th 2019.

# Changelog for Cldr_Units v2.4.0

This is the changelog for Cldr_units v2.4.0 released on March 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Supports `Cldr.default_backend()` as a default for `backend` parameters in `Cldr.Unit`

# Changelog for Cldr_Units v2.3.3

This is the changelog for Cldr_units v2.3.2 released on March 23rd, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Include `priv` directory in the hex package (thats where the conversion json exists)

# Changelog for Cldr_Units v2.3.2

This is the changelog for Cldr_units v2.3.2 released on March 20th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Bug Fixes

* Fix dialyzer warnings

# Changelog for Cldr_Units v2.3.1

This is the changelog for Cldr_units v2.3.1 released on March 15th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Makes generation of documentation for backend modules optional.  This is implemented by the `:generate_docs` option to the backend configuration.  The default is `true`. For example:

```
defmodule MyApp.Cldr do
  use Cldr,
    default_locale: "en-001",
    locales: ["en", "ja"],
    gettext: MyApp.Gettext,
    generate_docs: false
end
```

# Changelog for Cldr_Units v2.3.0

This is the changelog for Cldr_units v2.3.0 released on March 4th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* The conversion tables are now stored as json and updates may be downloaded at any time with the mix task `mix cldr.unit.download`. This means that updates to the conversion table may be made without requiring a new release of `Cldr.Unit`.

# Changelog for Cldr_Units v2.2.0

This is the changelog for Cldr_units v2.2.0 released on February 24th, 2019.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

This release is primarily about improving the conversion of units without introducing precision errors that accumulate for floats. The strategy is to define the conversion value between individual unit pairs.

Currently the implementation uses a static map.  In order to give users a better experience a future release will allow for both specifying mappings as a parameter to `Cldr.Unit.convert/2` and as compile time configuration options including the option to download conversion tables from the internet.

* Direct conversions are now supported. For some calculations, the process of diving and multiplying by conversion factors produces an unexpected result. Some direct conversions are now defined which produce a more expected result.

* In most cases, return integer values from conversion and decomposition when the originating unit value is also an integer

# Changelog for Cldr_Units v2.1.0

This is the changelog for Cldr_units v2.1.0 released on December 8th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Enhancements

* Add `Cldr.Unit.Conversion.convert!/2`

* Add `Cldr.Unit.Math.cmp/2`

* Add `Cldr.Unit.decompose/2`

* Add `Cldr.Unit.zero/1`

* Add `Cldr.Unit.zero?/1`

The appropriate backend equivalents are also added.

# Changelog for Cldr_Units v2.0.0

This is the changelog for Cldr_units v2.0.0 released on November 24th, 2018.  For older changelogs please consult the release tag on [GitHub](https://github.com/elixir-cldr/cldr_units/tags)

### Breaking changes

* `Cldr.Unit` now requires a `Cldr` backend module to be configured

* In order for the `String.Chars` protocol to be supported (which is used in string interpolation and by `Kernel.to_string/1`) a default backend must be configured.  For example in `config.exs`:
```
config :ex_cldr_units,
  default_backend: MyApp.Cldr
```

### Enhancements

* Move to a backend module structure with [ex_cldr](https://hex.pm/packages/ex_cldr) version 2.0