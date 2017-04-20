# Middleman Images Extension

Resize and optimize your images on the fly with Middleman. Just run `middleman build`
and all your images will get the minimizing treatment. **Middleman Images** currently
depends on [mini_magick](https://github.com/minimagick/minimagick) for resizing and
[image_optim](https://github.com/toy/image_optim) for optimizing your images.


[![Build Status](https://api.travis-ci.org/zweitag/middleman-images.png?branch=master)](https://travis-ci.org/zweitag/middleman-images)

* * *

## Installation

```ruby
gem 'middleman_images'
```

Resizing images requires ImageMagick to be available. Check
[mini_magick](https://github.com/minimagick/minimagick) for more information.

ImageOptim uses different tools to optimize image files. The easiest way to
make sure, most of these tools are available, is by including them via a seperate
gem:

```ruby
gem 'image_optim_pack'
```

For more information check [image_optim](https://github.com/toy/image_optim).

## Configuration

```ruby
activate :images
```

Configure the extension by passing a block to `:activate`.

```ruby
activate :images do |options|
  # Optimize all images by default (default: true) 
  optimize: true

  # Provide additional options for image_optim
  # See https://github.com/toy/image_optim for all available options
  image_optim: {
    nice: 20,
    optipng:
      level: 5
  }
end
```

## Usage

### Resize

To resize your images on build, set the option `resize` on the middleman helpers
`image_tag` and `image_path`.

```erb
<%= image_tag 'example.jpg', resize: '200x300' %>
```
becomes:

```html
<img src="/assets/images/example-200x300-opt.jpg" alt="Example" />
```

The image `example.jpg` will be resized, optimized and saved to `example-200x300-opt.jpg`.

### Optimize

You can disable (or enable) optimization for some images by providing the `optimize`
option.

```erb
<%= image_path 'example.jpg', resize: '200x300', optimize: false %>
```
becomes:

```html
/assets/images/example-200x300.jpg
```

### srcset

Using `srcset` with **Middleman Images** is possible via the `image_path`
helper. This is the prefered way in Middleman
(see [Middleman#File Size Optimization](https://middlemanapp.com/advanced/file-size-optimization)).

```erb
<img src="<%= image_path 'example.jpg', resize: '200x300' %>"
     srcset="<%= image_path 'example.jpg', resize: '400x600' %> 2x" />
```
