Feature: Building images

  Scenario: Building all images
    Given a fixture app "image"
    And a file named "config.rb" with:
      """
      activate :images
      """
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', optimize: true %>
      <%= image_tag 'images/fox.jpg', resize: '400x225', optimize: true %>
      <%= image_tag 'images/fox.jpg', resize: '400x225', optimize: false %>
      """
    And a successfully built app at "image"
    When I cd to "build"
    Then the following files should exist:
      | index.html |
      | images/fox.jpg |
      | images/fox-opt.jpg |
      | images/fox-400x225.jpg |
      | images/fox-400x225-opt.jpg |

  Scenario: Not building resources twice in a build
    Given a fixture app "image"
    And "images" feature is "enabled"
    And a template named "first.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', optimize: true %>
      """
    And a template named "second.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', optimize: true %>
      """
    And the Server is running
    And I go to "/first.html"
    And a modification time for a file named "/cache/images/fox-opt.jpg"
    When I go to "/second.html"
    Then the file "/cache/images/fox-opt.jpg" should not have been updated

  Scenario: Building image with asset_hash extension
    Given a fixture app "image"
    And a file named "config.rb" with:
      """
      activate :asset_hash
      activate :images
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And a successfully built app at "image"
    When I cd to "build/images"
    Then a file named "fox-opt.jpg" should not exist
    Then a file named "fox-opt-7b6ffc94.jpg" should exist

  Scenario: Not rebuilding unchanged resource
    Given a fixture app "image"
    And a file named "config.rb" with:
      """
      activate :images
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And a successfully built app at "image"
    And a modification time for a file named "/cache/images/fox-opt.jpg"
    When a successfully built app at "image"
    Then the file "/cache/images/fox-opt.jpg" should not have been updated


