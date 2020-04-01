defmodule Cldr.Unit.Preference do
  alias Cldr.Unit
  alias Cldr.Unit.Conversion
  alias Cldr.Unit.Conversion.Options

  @doc """
  Returns a list of the preferred units for a given
  unit, locale, territory and use case.

  The units used to represent length, volume and so on
  depend on a given territory, measurement system and usage.

  For example, in the US, people height is most commonly
  referred to in `inches`, or informally as `feet and inches`.
  In most of the rest of the world it is `centimeters`.

  ### Arguments

  * `unit` is any unit returned by `Cldr.Unit.new/2`.

  * `backend` is any Cldr backend module. That is, any module
    that includes `use Cldr`. The default is `Cldr.default_backend/0`

  * `options` is a keyword list of options or a
    `Cldr.Unit.Conversion.Options` struct. The default
    is `[]`.

  ### Options

  * `:usage` is the unit usage. for example `;person` for a unit
    of type `:length`. The available usage for a given unit category can
    be seen with `Cldr.Config.unit_preferences/0`. The default is `nil`.

  * `:scope` is either `:small` or `nil`. In some usage, the units
    used are different when the unit size is small. It is up to the
    developer to determine when `scope: :small` is appropriate.

  * `:alt` is either `:informal` or `nil`. Like `:scope`, the units
    in use depend on whether they are being used in a formal or informal
    context.

  * `:locale` is any locale returned by `Cldr.validate_locale/2`

  ### Returns

  * `{:ok, unit_list}` or

  * `{:error, {exception, reason}}`

  ### Examples

      iex> meter = Cldr.Unit.new :meter, 1
      #Unit<:meter, 1>
      iex> Cldr.Unit.Conversion.preferred_units meter, MyApp.Cldr, locale: "en-US", usage: :person, alt: :informal
      {:ok, [:foot, :inch]}
      iex> Cldr.Unit.Conversion.preferred_units meter, MyApp.Cldr, locale: "en-US", usage: :person
      {:ok, [:inch]}
      iex> Cldr.Unit.Conversion.preferred_units meter, MyApp.Cldr, locale: "en-AU", usage: :person
      {:ok, [:centimeter]}
      iex> Cldr.Unit.Conversion.preferred_units meter, MyApp.Cldr, locale: "en-US", usage: :road
      {:ok, [:mile]}
      iex> Cldr.Unit.Conversion.preferred_units meter, MyApp.Cldr, locale: "en-AU", usage: :road
      {:ok, [:kilometer]}

  ### Notes

  One common pattern is to convert a given unit into the unit
  appropriate for a given local and usage. This can be
  accomplished with a combination of `Cldr.Unit.Conversion.preferred_units/2`
  and `Cldr.Unit.decompose/2`. For example:

      iex> meter = Cldr.Unit.new(:meter, 1)
      iex> preferred_units = Cldr.Unit.preferred_units(meter, MyApp.Cldr, locale: "en-US", usage: :person)
      iex> with {:ok, preferred_units} <- preferred_units do
      ...>   Cldr.Unit.decompose(meter, preferred_units)
      ...> end
      [Cldr.Unit.new(:foot, 3), Cldr.Unit.new(:inch, 3)]

  """
  def preferred_units(unit, backend, options \\ [])

  def preferred_units(%Unit{} = unit, options, []) when is_list(options) do
    with {:ok, options} <- validate_preference_options(options) do
      preferred_units(unit, options.backend, options)
    end
  end

  def preferred_units(%Unit{} = unit, backend, options) when is_list(options) do
    with {:ok, options} <- validate_preference_options(backend, options) do
      preferred_units(unit, backend, options)
    end
  end

  def preferred_units(%Unit{} = unit, _backend, %Options{} = options) do
    %{usage: usage, territory: territory} = options
    geq = Conversion.convert_to_base_unit(unit) |> Unit.value
    category = Unit.unit_category(unit)

    with {:ok, usage} <- validate_usage(category, usage) do
      territory_chain =
        territory
        |> Cldr.territory_chain
        |> List.insert_at(0, territory)
        |> Enum.uniq

      preferred_units(category, usage, territory_chain, geq)
    end
  end

  defp validate_usage(category, usage) do
    if get_in(Unit.unit_preferences(), [category, usage]) do
      {:ok, usage}
    else
      {:error, "undefined usage"}
    end
  end


  @doc """
  Returns a list of the preferred units for a given
  unit, locale, territory and use case.

  The units used to represent length, volume and so on
  depend on a given territory, measurement system and usage.

  For example, in the US, people height is most commonly
  referred to in `inches`, or `feet and inches`.
  In most of the rest of the world it is `centimeters`.

  ### Arguments

  * `unit` is any unit returned by `Cldr.Unit.new/2`.

  * `backend` is any Cldr backend module. That is, any module
    that includes `use Cldr`. The default is `Cldr.default_backend/0`

  * `options` is a keyword list of options or a
    `Cldr.Unit.Conversion.Options` struct. The default
    is `[]`.

  ### Options

  * `:locale` is any valid locale name returned by `Cldr.known_locale_names/0`
    or a `Cldr.LanguageTag` struct.  The default is `backend.get_locale/0`

  * `:territory` is any valid territory code returned by
    `Cldr.known_territories/0`. The default is the territory defined
    as part of the `:locale`. The option `:territory` has a precedence
    over the territory in a locale.

  * `:usage` is the way in which the unit is intended
    to be used.  The available `usage` varyies according
    to the unit category.  See `Cldr.Unit.unit_preferences/0`.

  ### Returns

  * `unit_list` or

  * raises an exception

  ### Examples

      iex> meter = Cldr.Unit.new :meter, 1
      #Unit<:meter, 1>
      iex> Cldr.Unit.Conversion.preferred_units! meter, MyApp.Cldr, locale: "en-US", usage: :person
      [:foot, :inch]
      iex> Cldr.Unit.Conversion.preferred_units! meter, MyApp.Cldr, locale: "en-US", usage: :person
      [:inch]
      iex> Cldr.Unit.Conversion.preferred_units! meter, MyApp.Cldr, locale: "en-AU", usage: :person
      [:centimeter]
      iex> Cldr.Unit.Conversion.preferred_units! meter, MyApp.Cldr, locale: "en-US", usage: :road
      [:mile]
      iex> Cldr.Unit.Conversion.preferred_units! meter, MyApp.Cldr, locale: "en-AU", usage: :road
      [:kilometer]

  """
  def preferred_units!(unit, backend, options \\ []) do
    case preferred_units(unit, backend, options) do
      {:ok, preferred_units} -> preferred_units
      {:error, {exception, reason}} -> raise exception, reason
    end
  end

  defp validate_preference_options(backend, options) when is_list(options) do
    options
    |> Keyword.put(:backend, backend)
    |> validate_preference_options
  end

  defp validate_preference_options(options) when is_list(options) do
    backend = Keyword.get_lazy(options, :backend, &Cldr.default_backend/0)
    locale = Keyword.get_lazy(options, :locale, &backend.get_locale/0)
    territory = Keyword.get(options, :territory, locale.territory)
    usage = Keyword.get(options, :usage, :default)

    with {:ok, locale} <- backend.validate_locale(locale),
         {:ok, territory} <- Cldr.validate_territory(territory) do
      options = [locale: locale, territory: territory, usage: usage, backend: backend]
      {:ok, struct(Options, options)}
    end
  end

  for {category, usages} <- Unit.unit_preferences() do
    for {usage, preferences} <- usages do
      for preference <- preferences do
        with %{geq: geq, regions: regions, units: units} <- preference,
             %Unit{value: value} <- Conversion.convert_to_base_unit(units) do
          geq = value * geq
          def preferred_units(unquote(category), unquote(usage), region, value)
              when region in unquote(regions) and value >= unquote(geq) do
           {:ok, unquote(units)}
          end
        else _other ->
          # IO.puts "Unable to generate functions for #{inspect preference}"
          # IO.inspect other
          nil
        end
      end
    end
  end

  def preferred_units(category, usage, region, value) when is_atom(region) do
    {:error, unknown_preferences_error(category, usage, region, value)}
  end

  def preferred_units(category, usage, [region], value) do
    preferred_units(category, usage, region, value)
  end

  def preferred_units(category, usage, [region | other_regions], value) do
    case preferred_units(category, usage, region, value) do
      {:ok, units} -> {:ok, units}
      _other -> preferred_units(category, usage, other_regions, value)
    end
  end

  def unknown_preferences_error(category, usage, regions, value) do
    {
      Cldr.Unit.UnknownUnitPreferenceError,
      "No preferences found for #{inspect category} " <>
      "with usage #{inspect usage} " <>
      "for region #{inspect regions} and " <>
      "value #{inspect value}"
    }
  end
end