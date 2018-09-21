# InstantSearch iOS: Examples
>Example apps built with [algolia/instantsearch-ios](https://github.com/algolia/instantsearch-ios).

**InstantSearch iOS** is a library providing widgets and helpers to help you build the best instant-search experience on iOS with Algolia. It is built on top of Algolia's [Swift API Client](https://github.com/algolia/algoliasearch-client-swift) to provide you a high-level solution to quickly build various search interfaces.

## Examples
We have built a demo application to give you an idea of what you can build with InstantSearch iOS:

## [E-commerce Demo App](https://github.com/algolia/instantsearch-ios-examples/tree/master/ecommerce%20Demo)
<img src="./docs/ecommerce.png" align="right" width="300"/>

This example imitates a product search interface like well-known e-commerce applications.

- Search in the **product's name**, **type**, and **category**
- Filter with RefinementList by **type** or **category**
- Filter with Numeric filters by **price** or **rating**
- Custom views using `AlgoliaWidget` for filtering by **price** and **rating**.

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

## [Tourism application](https://github.com/algolia/instantsearch-ios-examples/tree/master/Icebnb)
<img src="./docs/icebnb.gif" align="right" width="300"/>

Example of a bed and breakfast search interface.

- Search a place by **your location** around you
- Filter with Numberic filters by **radius**
- Filter with RefinementList by **room_type**
- Filter with Numeric filters by **price**
- Custom views using `AlgoliaWidget` for filtering by **price** and **room_type**
- Custom widgets for linking the search results with the `MKMapView`

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

## [Query Suggestions](https://github.com/algolia/instantsearch-ios-examples/tree/master/Query%20Suggestions)
<img src="./docs/suggestion.gif" align="right" width="300"/>

Example of a query suggestion search interface.

- Query suggestions appear when clicking on the search bar
- When clicking a query suggestion, the search bar is filled with that suggestion and results are refreshed
- Showing how you can use the ViewModels for better control and customization of your widgets

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

## [Movies Demo](https://github.com/algolia/instantsearch-ios-examples/tree/master/Movies)
<img src="./docs/Movies.gif" align="right" width="300"/>

Example of a multi-index search interface.

- Multi-Index table showcasing results from different indices (movies and actors)
- A load more button taking you to an infinite scrolling list
- Keep the state of the search when moving to the load more screen
- Uses the new iOS 11 SearchBar in NavigationBar.