# Middleman Images Extension

Resize and optimize your images on the fly with Middleman. Just run `middleman build`
and all your images will get the minimizing treatment. *Middleman Images* currently
depends on [mini_magick](https://github.com/minimagick/minimagick) for resizing and
[image_optim](https://github.com/toy/image_optim) for optimizing your images.


[![Build Status](https://api.travis-ci.org/zweitag/middleman-images.png?branch=master)](https://travis-ci.org/zweitag/middleman-images)

* * *

## Installation

```ruby
gem 'middleman-images'
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

You most likely only want images to be processed on build. So activate
the extension `images` for the build scope.

```ruby
configure :build do
  activate :images
end
```

Configure the extension by passing a block to `:activate`.

```ruby
configure :build do
  activate :images do |images|
    # Optimize all images by default (default: true) 
    images.optimize = true

    # Provide additional options for image_optim
    # See https://github.com/toy/image_optim for all available options
    images.image_optim = {
      nice: 20,
      optipng:
        level: 5
    }
  end
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

Using `srcset` with *Middleman Images* is possible via the `image_path`
helper. Corresponding to the way Middleman handles this in conjunction with the
`:asset_hash` option
(see [Middleman#File Size Optimization](https://middlemanapp.com/advanced/file-size-optimization)).

```erb
<img src="<%= image_path 'example.jpg', resize: '200x300' %>"
     srcset="<%= image_path 'example.jpg', resize: '400x600' %> 2x" />
```

### Cache

*Middleman Images* will create a `cache` Folder in your app directory. It will
save the processed images in there. This is necessary to work with other plugins
like `asset_hash` and to make sure unchanged images are not reprocessed on
rebuild. Deleting this directory is not critical, but it will force
*Middleman Images* to rebuild **all** images on the next build, so you should
do this with care.
