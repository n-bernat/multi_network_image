# Multi Network Image

[![Package](https://img.shields.io/pub/v/multi_network_image.svg)](https://pub.dev/packages/multi_network_image) [![Publisher](https://img.shields.io/pub/publisher/multi_network_image.svg)](https://pub.dev/packages/multi_network_image/publisher) [![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT) [![LeanCode Style](https://img.shields.io/badge/style-leancode__lint-black)](https://pub.dartlang.org/packages/leancode_lint)

`multi_network_image` is a package that allows you to handle adaptive images with ease.

|                                                                                                                   Status                                                                                                                    |               Comments               |
| :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------: |
| [![multi_network_image - Tests (stable)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_stable.yaml/badge.svg)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_stable.yaml) |    Current stable Flutter version    |
|    [![multi_network_image - Tests (beta)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_beta.yaml/badge.svg)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_beta.yaml)    |     Current beta Flutter version     |
|    [![multi_network_image - Tests (3.27.0)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_min.yaml/badge.svg)](https://github.com/n-bernat/flutter_multi_network_image/actions/workflows/test_min.yaml)    | The oldest supported Flutter version |

## Getting started

1. Add this package to your dependencies.

```yaml
dependencies:
  multi_network_image: latest_version
```

2. Get the dependencies.

```sh
flutter pub get
```

3. Use `MultiNetworkImage` as a source for your `Image`.

```dart
return Image(
  image: MultiNetworkImage([
    // The main image that we want to display.
    'https://picsum.photos/2000',
    // You can provide additional images that will be used
    // as a fallback if the main image is not available.
    'https://picsum.photos/200',
    // The low-quality image that, if cached, will be used
    // as a placeholder.
    'https://picsum.photos/20',
  ]),
);
```

## Details

`MultiNetworkImage` will look for the first image that is both provided in the list and is cached, and will use it as an initial source.

After that (of if no image is cached), it will try to fetch the first image from the list. If it fails, it will try the next one, and so on.

It allows you to provide a low-quality image as a fallback, and a high-quality image as a primary source.

## Additional information

- This package requires at least Flutter 3.27.0 to work.
- If there are any issues feel free to go to [GitHub Issues](https://github.com/n-bernat/flutter_multi_network_image/issues) and report a bug.

## Maintainers

- [Nikodem Bernat](https://nikodembernat.com)
