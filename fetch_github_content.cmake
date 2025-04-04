include(FetchContent)

function(fetch_github_content)
  set(arguments ${ARGV})
  set(arguments_amount ${ARGC})

  macro(check_arguments_amount)
    block()
      math(EXPR max "${arguments_amount} - 3")
      if(${index} GREATER ${max})
        message(FATAL_ERROR "Not enough arguments.")
      endif()
    endblock()
  endmacro()

  macro(compute_repository_variables)
    pop_next_value(repository)
    pop_next_value(author)
    pop_next_value(tag)
  endmacro()

  macro(fetch_repository)
    FetchContent_Declare(
      ${repository}
      GIT_REPOSITORY https://github.com/${author}/${repository}.git
      GIT_TAG ${tag}
    )
    FetchContent_MakeAvailable(${repository})
    string(TOLOWER ${repository} repository_lower)
    propagate_variables(
      ${repository_lower}_POPULATED
      ${repository_lower}_SOURCE_DIR
      ${repository_lower}_BINARY_DIR
    )
  endmacro()

  macro(compute_include_paths)
    block(PROPAGATE include_paths index)
      macro(add_include_path path)
        list(APPEND include_paths ${${repository}_SOURCE_DIR}/${path}.cmake)
      endmacro()

      macro(check_index)
        block()
          list(LENGTH arguments max)
          if(index GREATER_EQUAL max)
            break()
          endif()
        endblock()
      endmacro()

      while(TRUE)
        check_index()
        get_next_value(value)
        if(value STREQUAL "INCLUDE_DEFAULT")
          increase_index()
          add_include_path(${repository})
        elseif(value STREQUAL "INCLUDE")
          increase_index()
          pop_next_value(include_path)
          add_include_path(${include_path})
        else()
          break()
        endif()
      endwhile()
    endblock()
  endmacro()

  macro(include_modules)
    foreach(path IN LISTS include_paths)
      include(${path})
    endforeach()
    unset(include_paths)
  endmacro()

  macro(increase_index)
    math(EXPR index "${index} + 1")
  endmacro()

  macro(get_next_value output_variable)
    list(GET arguments ${index} ${output_variable})
  endmacro()

  macro(pop_next_value output_variable)
    get_next_value(${output_variable})
    increase_index()
  endmacro()

  macro(propagate_variables)
    foreach(variable ${ARGV})
      set(${variable} ${${variable}} PARENT_SCOPE)
    endforeach()
  endmacro()

  set(index 0)
  while(${index} LESS ${ARGC})
    check_arguments_amount()
    compute_repository_variables()
    fetch_repository()
    compute_include_paths()
    include_modules()
  endwhile()
endfunction()