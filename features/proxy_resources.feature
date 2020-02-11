
Feature: Proxy resources

  Scenario: Resizing images for a proxy resource on build
    Given a fixture app "image"
    And a middleman configuration with:
      """
      activate :i18n, langs: [:en, :de], mount_at_root: false
      """
    And our extension is enabled
    And a template named "localizable/index.html.erb" with:
      """
      <%= image_tag 'fox.jpg', resize: (I18n.locale == :en ? 400 : 500) %>
      """
    When a successfully built app at "image"
    When I cd to "build/images"
    Then a file named "fox-400.jpg" should exist
    And a file named "fox-500.jpg" should exist

  Scenario: Resizing images for a proxy resource on server
    Given a fixture app "image"
    And a middleman configuration with:
      """
      activate :i18n, langs: [:en, :de], mount_at_root: false
      """
    And our extension is enabled
    And a template named "localizable/index.html.erb" with:
      """
      <%= image_tag 'fox.jpg', resize: (I18n.locale == :en ? 400 : 500) %>
      """
    And the Server is running
    When I go to "/en/index.html"
    Then I should see '<img src="/images/fox-400.jpg" alt="Fox" />'
    When I go to "/images/fox-400.jpg"
    Then the status code should be "200"
    When I go to "/de/index.html"
    Then I should see '<img src="/images/fox-500.jpg" alt="Fox" />'
    When I go to "/images/fox-500.jpg"
    Then the status code should be "200"
