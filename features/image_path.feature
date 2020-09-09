Feature: image_path helper

  Scenario: image_path with options
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg', resize: "400x225", optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/fox-400x225-opt.jpg'
    When I go to "/images/fox-400x225-opt.jpg"
    Then the status code should be "200"

  Scenario: image_path without options
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path '/images/fox.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/fox-opt.jpg'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"

  Scenario: image_path with unavailable image file
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path 'nofile.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/nofile.jpg'
    When I go to "/images/nofile.jpg"
    Then the status code should be "404"

  Scenario: image_path with asset_hash extension
    Given a fixture app "image"
    And our extension is enabled
    And "asset_hash" feature is "enabled"
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/images/fox-opt-4eaecd94.jpg'
    When I go to "/images/fox-opt-4eaecd94.jpg"
    Then the status code should be "200"

  Scenario: image_path with http_prefix config
    Given a fixture app "image"
    And our extension is enabled
    And I append to "config.rb" with:
      """
      set :http_prefix, "/my/prefix"
      """
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', resize: "400x225" %>
      """
    And the Server is running
    When I go to "/index.html"
    Then I should see '/my/prefix/images/fox-400x225.jpg'

  Scenario: image_path in CSS file
    Given a fixture app "image"
    And our extension is enabled
    And a file named "source/stylesheets/app.css.erb" with:
      """
      body { background: url("<%= image_path 'images/fox.jpg', optimize: true %>") }
      """
    And the Server is running
    When I go to "/stylesheets/app.css"
    Then I should see 'body { background: url("/images/fox-opt.jpg") }'
    When I go to "/images/fox-opt.jpg"
    Then the status code should be "200"
