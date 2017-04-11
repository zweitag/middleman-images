Feature: Building images

  Scenario: building all images
    Given a fixture app "image_tag"
    And a file named "config.rb" with:
      """
      activate :images
      """
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg' %>
      <%= image_tag 'images/fox.jpg', resize: '400x225' %>
      <%= image_tag 'images/fox.jpg', resize: '400x225', optimize: false %>
      """
    And a successfully built app at "image_tag"
    When I cd to "build"
    Then the following files should exist:
      | index.html |
      | images/fox.jpg |
      | images/fox-opt.jpg |
      | images/fox-400x225.jpg |
      | images/fox-400x225-opt.jpg |
