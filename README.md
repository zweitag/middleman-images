# Middleman Images Extension

Resize and optimize your images on the fly with Middleman. Just run `middleman build`
and all your images will get the minimizing treatment. *Middleman Images* currently
depends on [mini_magick](https://github.com/minimagick/minimagick) for resizing and
[image_optim](https://github.com/toy/image_optim) for optimizing your images.


[![Build Status](https://travis-ci.org/zweitag/middleman_images.png?branch=master)](https://travis-ci.org/zweitag/middleman_images)

* * *

## Installation

```ruby
gem 'middleman_images'
```

Resizing images requires ImageMagick to be available. Check
[mini_magick](https://github.com/minimagick/minimagick) for more information.

ImageOptim uses different tools to optimize image files. The easiest way to
make sure those tools are available is by including gem with a pack of these tools:

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
  # Optimize all images by default 
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

You can now use the option `resize` on the middleman helpers `image_tag` and
`image_path` to replace the images with their resized versions on build.

Input:
```erb
<%= image_tag 'example.jpg', resize: '200x300' %>
```

Output:
```html
<img src="/assets/images/example-200x300-opt.jpg" alt="Example" />
```

The image `example.jpg` will be resized, optimized and saved to `example-200x300-opt.jpg`.

You can disable (or enable) optimization for some images by providing the `optimize`
option.

Input:
```erb
<%= image_path 'example.jpg', resize: '200x300', optimize: false %>
```

Output:
```html
/assets/images/example-200x300.jpg
```

### `srcset`

Using `srcset` with *Middleman Images* is currently only possible via the `image_path`
helper:

```erb
<img src="<%= image_path 'example.jpg', resize: '200x300' %>"
     srcset="<%= image_path 'example.jpg', resize: '400x600' %> 2x" />
```
