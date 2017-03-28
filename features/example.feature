Feature: Image resizing

  Scenario: image_tag with resize
    Given the Server is running at "example"
    When I go to "/example.html"
    Then I should see '<img src="/images/fox-400x400.jpg"'

  Scenario: resized image
    Given the Server is running at "example"
    When I go to "/example.html"
    And I go to "/images/fox-400x400.jpg"
    Then I should not see "File Not Found"

  Scenario: building resized image
    Given a successfully built app at "example"
    When I cd to "build"
    Then the following files should exist:
      | example.html |
      | images/fox.jpg |
      | images/fox-400x400.jpg |
