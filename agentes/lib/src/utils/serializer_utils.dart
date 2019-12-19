import 'package:built_value/serializer.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';

var serializers =
    (Serializers().toBuilder()..add(Iso8601DateTimeSerializer())).build();

var data = DateTime.utc(1980, 1, 2, 3, 4, 5, 6, 7);
var serialized = '1980-01-02T03:04:05.006007Z';
//2019-12-04T15:59:40.0470000-07:00
var specifiedType = FullType(DateTime);

DateTime convertDateTimeToIso8601() {
  return serializers.serialize(data, specifiedType: specifiedType);
}

DateTime convertIso8601ToDateTime(String date) {
  return serializers.deserialize(date, specifiedType: specifiedType);
}
