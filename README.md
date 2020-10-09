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

# For resizing images:
gem 'mini_magick'

# For optimizing images:
gem 'image_optim'
```

Resizing images requires the gem `mini_magick` and ImageMagick binaries to be
available. Check [`mini_magick`](https://github.com/minimagick/minimagick) for
more information.

Optimizing images require the gem `image_optim`.
Check [`image_optim`](https://github.com/toy/image_optim) for more information.

ImageOptim uses different tools to optimize image files. The easiest way to
make sure, most of these tools are available, is by including them via a seperate
gem:

```ruby
gem 'image_optim_pack'
```

For more information check [`image_optim_pack`](https://github.com/toy/image_optim_pack)

## Configuration

To activate the extension just put this into your `config.rb`:

```ruby
activate :images
```

With Middleman images activated, starting the Middleman server will take some time.
During that time images that need procssing will get registered.
The actual processing of the images takes place while navigating the page.

Configure the extension by passing a block to `:activate`:

```ruby
activate :images do |images|
  # Do not include original images in the build (default: false)
  images.ignore_original = true

  # Specify another cache directory depending on your root directory (default: 'cache')
  images.cache_dir = 'funky_cache/subdir_of_funky_cache'

  # Optimize images (default: false)
  images.optimize = true

  # Provide additional options for image_optim
  # See https://github.com/toy/image_optim for all available options
  images.image_optim = {
    nice: 20,
    optipng: {
      level: 5,
    },
  }
end
```

By default *Middleman Images* won't do anything to your images.

## Usage

Middleman images supports a wide variety of options. You can look up all actions in [the ImageMagick documentation](https://www.imagemagick.org/script/command-line-options.php).

### Resize

To resize your images, set the option `resize` on the middleman helpers `image_tag` or `image_path`.

```erb
<%= image_tag 'example.jpg', resize: '200x300' %>
```

becomes:

```html
<img src="/assets/images/example-200x300-opt.jpg" alt="Example" />
```

The image `example.jpg` will be resized, optimized and saved to `example-200x300-opt.jpg`.

We use ImageMagick for resizing, which respects the aspect ratio of your images when resizing. You can make ImageMagick ignore the aspect ratio by appending `!` to `resize`.

```erb
<%= image_tag 'example.jpg', resize: '200x300!' %>
```

Since *Middleman Images* just passes the `resize` string to ImageMagick, you can use all options available. Check the [ImageMagick documentation for resize](https://www.imagemagick.org/Usage/resize/#resize) for all available options.

### Crop

To crop your images, set the option `crop` on the middleman helpers `image_tag` or `image_path`.

```erb
<%= image_path 'example.jpg', crop: '200x300' %>
```

### Optimize

You can enable (or disable) optimization for some images by providing the `optimize`
option.

```erb
<%= image_path 'example.jpg', resize: '200x300', optimize: false %>
```

becomes:

```html
/assets/images/example-200x300.jpg
```

### srcset

Using `srcset` with *Middleman Images* is possible via the `image_path` helper. This is how Middleman handles srcsets in conjunction with the
`:asset_hash` option
(see [Middleman#File Size Optimization](https://middlemanapp.com/advanced/file-size-optimization)).

```erb
<img src="<%= image_path 'example.jpg', resize: '200x300' %>"
     srcset="<%= image_path 'example.jpg', resize: '400x600' %> 2x" />
```

### Cache

*Middleman Images* will create a `cache` Folder in your app directory
(or the folder name you specified as `cache_dir`). It will
save the processed images in there. This is necessary to work with other plugins
like `asset_hash` and to make sure unchanged images are not reprocessed on
rebuild. Deleting this directory is not critical, but it will force
*Middleman Images* to rebuild **all** images on the next build, so you should
do this with care.
