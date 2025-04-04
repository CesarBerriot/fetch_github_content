# Integration
```cmake
include(FetchContent)
FetchContent_Declare(fetch_github_content GIT_REPOSITORY https://github.com/CesarBerriot/fetch_github_content.git GIT_TAG 1.0.0)
FetchContent_MakeAvailable(fetch_github_content)
include(${fetch_github_content_SOURCE_DIR}/fetch_github_content.cmake)
```

# Usage
```cmake
fetch_github_content(
  <repository> <author> <tag> [INCLUDE_DEFAULT] [INCLUDE <module path>] [INCLUDE <other module path>]
  <repository> <author> <tag>
  <repository> <author> <tag>
)
```

# Reference
`INCLUDE_DEFAULT` \
Includes `<repository>.cmake` from the fetched repository's source directory.

`INCLUDE <module path>` \
Includes `./<module path>.cmake` from the fetched repository's source directory.