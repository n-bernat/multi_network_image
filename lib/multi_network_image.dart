import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// A widget that allows you to handle adaptive images.
class MultiNetworkImage extends ImageProvider<MultiNetworkImage> {
  /// Creates a new [MultiNetworkImage] instance.
  const MultiNetworkImage(this.urls, {this.scale = 1.0, this.headers});

  /// The list of URLs to the images.
  final List<String> urls;

  /// The scale of the image.
  final double scale;

  /// The headers to use when fetching the images.
  final Map<String, String>? headers;

  @override
  Future<MultiNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MultiNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    MultiNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    final images = urls.map(
      (url) => NetworkImage(
        url,
        scale: scale,
        headers: headers,
      ),
    );

    final cached = images.firstWhereOrNull(
      PaintingBinding.instance.imageCache.containsKey,
    );

    return _MultiImageCompleter(
      cached: cached,
      images: images,
    );
  }
}

class _MultiImageCompleter extends ImageStreamCompleter {
  _MultiImageCompleter({
    required NetworkImage? cached,
    required Iterable<NetworkImage> images,
  }) {
    if (cached case final cached?) {
      _loadCachedImage(cached);
    }

    _loadNetworkImage(images);
  }

  var _hasImage = false;

  /// Loads the image from the cache.
  void _loadCachedImage(NetworkImage image) {
    try {
      final completer = PaintingBinding.instance.imageCache.putIfAbsent(
        image,
        () => image.loadImage(
          image,
          PaintingBinding.instance.instantiateImageCodecWithSize,
        ),
      );

      ImageInfo? imageInfo;
      completer?.addListener(
        ImageStreamListener((image, _) => imageInfo = image),
      );

      if (!_hasImage && imageInfo != null) {
        _hasImage = true;
        setImage(imageInfo!);
      }
    } catch (_) {
      // Failed to load from cache, try to load from network.
    }
  }

  /// Loads the image from the network.
  /// Returns `true` if the image was loaded successfully, `false` otherwise.
  Future<void> _loadNetworkImage(Iterable<NetworkImage> images) async {
    for (final image in images) {
      try {
        final completer = _NetworkImageCompleter(image);
        final imageInfo = await completer.load();

        _hasImage = true;
        setImage(imageInfo);
        return;
      } catch (e) {
        // Skip to the next image if the current image fails to load.
        continue;
      }
    }

    throw Exception('Failed to load any image');
  }
}

class _NetworkImageCompleter {
  _NetworkImageCompleter(this.image);
  final NetworkImage image;

  final _completer = Completer<ImageInfo>();

  Future<ImageInfo> load() {
    final cacheCompleter = PaintingBinding.instance.imageCache.putIfAbsent(
      image,
      () => image.loadImage(
        image,
        PaintingBinding.instance.instantiateImageCodecWithSize,
      ),
    );

    if (cacheCompleter == null) {
      throw Exception('Failed to load image');
    }

    cacheCompleter.addListener(
      ImageStreamListener(
        (image, _) => _completer.complete(image),
        onError: _completer.completeError,
      ),
    );

    return _completer.future;
  }
}
