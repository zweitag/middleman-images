Feature: Image resizing

  Scenario: image_tag with resize
    Given the Server is running at "example"
    When I go to "/example.html"
    Then I should see '<img src="/images/fox-400x225.jpg"'

  Scenario: resized image
    Given the Server is running at "example"
    When I go to "/example.html"
    And I go to "/images/fox-400x225.jpg"
    Then the status code should be "200"

  Scenario: building images (config: optimize => true)
    Given a successfully built app at "example"
    When I cd to "build"
    Then the following files should exist:
      | example.html |
      | images/fox.jpg |
      | images/fox-opt.jpg |
      | images/fox-400x225.jpg |
      | images/fox-400x225-opt.jpg |
    Then the dimensions of the file "./images/fox-400x225.jpg" should be 400x225
    Then the dimensions of the file "./images/fox-400x225-opt.jpg" should be 400x225
    Then the file "./images/fox-400x225-opt.jpg" should be smaller than the file "./images/fox-400x225.jpg"
    Then the file "./images/fox-opt.jpg" should be smaller than the file "./images/fox.jpg"

  Scenario: building images (config: optimize => false)
    Given a fixture app "example"
      And app "example" is using config "nopt"
      And a successfully built app at "example"
    When I cd to "build"
    Then the following files should exist:
      | example.html |
      | images/fox.jpg |
      | images/fox-400x225.jpg |
      | images/fox-400x225-opt.jpg |
    Then the following files should not exist:
      | images/fox-opt.jpg |
    Then the dimensions of the file "./images/fox-400x225.jpg" should be 400x225
    Then the dimensions of the file "./images/fox-400x225-opt.jpg" should be 400x225
    Then the file "./images/fox-400x225-opt.jpg" should be smaller than the file "./images/fox-400x225.jpg"
