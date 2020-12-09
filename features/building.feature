Feature: Building images

  Scenario: Building all images
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', optimize: true %>
      <%= image_tag 'images/fox.jpg', resize: '400x225', optimize: true %>
      <%= image_tag 'images/fox.jpg', resize: '400x225', optimize: false %>
      <%= image_tag 'images/fox.jpg', blur: '42',
                                      colorspace: 'Gray',
                                      colorize: '0,42,0',
                                      crop: '413x123!+0+0',
                                      edge: '23',
                                      resize: '400x225',
                                      rotate: '-90' %>
      """
    And a successfully built app at "image"
    When I cd to "build"
    Then the following files should exist:
      | index.html                 |
      | images/fox.jpg             |
      | images/fox-opt.jpg         |
      | images/fox-400x225.jpg     |
      | images/fox-400x225-opt.jpg |
      | images/fox-3f68a48bd34dff1d3cb6c40a1d6a6bd377a102e7.jpg |

  Scenario: Not building resources twice in a build
    Given a fixture app "image"
    And our extension is enabled
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
    And I go to "/images/fox-opt.jpg"
    And a modification time for a file named "cache/images/fox-opt.jpg"
    And I go to "/second.html"
    When I go to "/images/fox-opt.jpg"
    Then the file "cache/images/fox-opt.jpg" should exist
    Then the file "cache/images/fox-opt.jpg" should not have been updated

  Scenario: Building image with asset_hash extension
    Given a fixture app "image"
    And our extension is enabled
    And I append to "config.rb" with:
      """
      activate :asset_hash
      """
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And a successfully built app at "image"
    When I cd to "build/images"
    Then a file named "fox-opt.jpg" should not exist
    Then a file named "fox-opt-4eaecd94.jpg" should exist

  Scenario: Not rebuilding unchanged resource
    Given a fixture app "image"
    And our extension is enabled
    And a template named "index.html.erb" with:
      """
      <%= image_path 'images/fox.jpg', optimize: true %>
      """
    And a successfully built app at "image"
    And a modification time for a file named "cache/images/fox-opt.jpg"
    When a successfully built app at "image"
    Then the file "cache/images/fox-opt.jpg" should exist
    Then the file "cache/images/fox-opt.jpg" should not have been updated

  Scenario: Building all images in a custom cache directory
    Given a fixture app "image"
    And our extension is enabled with:
      """
      config.cache_dir = 'custom/cache'
      """
    And a template named "index.html.erb" with:
      """
      <%= image_tag 'images/fox.jpg', optimize: true %>
      """
    When a successfully built app at "image"
    Then the file "custom/cache/images/fox-opt.jpg" should exist
