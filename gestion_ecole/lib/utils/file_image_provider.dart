import 'file_image_provider_io.dart'
    if (dart.library.html) 'file_image_provider_stub.dart';

import 'package:flutter/widgets.dart';

ImageProvider<Object>? fileImageProvider(String path) =>
    fileImageProviderImpl(path);
