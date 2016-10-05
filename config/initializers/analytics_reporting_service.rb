require 'google/apis/analyticsreporting_v4'
$analytics_reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
$analytics_reporting_service.authorization = Google::Auth.get_application_default(
  ['https://www.googleapis.com/auth/analytics.readonly'])



# require 'google/apis/analyticsreporting_v4'
# scopes = ["https://www.googleapis.com/auth/analytics.readonly"]
# auth = Google::Auth.get_application_default(scopes)
# $analytics_reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
# #$analytics_reporting_service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/analytics.readonly'])
# $analytics_reporting_service.authorization = auth
# $analytics_reporting_service.authorization.fetch_access_token!
