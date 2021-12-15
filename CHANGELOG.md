# Changelog

## v0.12.0 (2021-12-15)

* Add get_alert to Alert API #65 (inommm, pyto86)
* Send query parameters to alerts api #64 (kenchan)

## v0.11.0 (2021-03-24)

* Implements downtime API #61 (myoan)

## v0.10.0 (2021-03-15)

## Breaking change

Previously `Host` has `type` attribute, but it is removed.

* Drop `type` attribute from `Host` and introduce `size` instead #58 (astj)

## v0.9.0 (2020-01-23)

* Use Faraday v1.0 #54 (onk)

## v0.8.0 (2019-06-26)

### Breaking change

Now mackerel-client raises `Mackerel::Error` when HTTP requests failed.
Previously various exceptions (mainly `RuntimeError` or `NoMethodError`) happened in such cases.

* Use Faraday::Response::RaiseError middleware #49 (onk)

## v0.7.0 (2018-10-22)

* fix unintended initializing http headers #47 (y_uuki)

## v0.6.0 (2018-07-04)

* Use Rspec v3.x #43 (onk)

