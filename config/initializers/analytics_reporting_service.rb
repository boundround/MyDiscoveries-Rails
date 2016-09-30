require 'google/apis/analyticsreporting_v4'
$analytics_reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
$analytics_reporting_service.authorization = Google::Auth.get_application_default(
  ['https://www.googleapis.com/auth/analytics.readonly'])
