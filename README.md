# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 14 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] AutoLayout
- [x] Stack View

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Flicks](FlixX0r.gif)

Network Request Error:

![Network request error](network_error.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/). README edited with [Atom](https://atom.io/). Podfile edited with [emacs](https://www.gnu.org/software/emacs/).

## Notes

- In the movie detail view, with a very large blob of text (more than space avail. on screen / view) for "overview", I couldn't figure out how to have the text truncate to ... *while* simultaneously not having movies with very sparse text for "overview" to center vertically (i.e. I still want the sparse text starting just below the "title")

## License

[www.jayliew.com](http://www.jayliew.com)

    Copyright 2016 Jay S. Liew

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
