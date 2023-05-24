// https://stackoverflow.com/a/67435226

T? castOrNull<T>(dynamic x) => x is T ? x : null;
