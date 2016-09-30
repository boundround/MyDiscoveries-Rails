class GoogleAnalyticsPageViewsCounter
  START_DATE = '2012-01-09' # boundround.com Creation Date: 2012-01-09

  def initialize(page_path)
    @page_path = page_path
  end

  def call
    report.data.totals.first.values.first.to_i
  end

  private

  def dimension
    Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:pagePath')
  end

  def metric
    Google::Apis::AnalyticsreportingV4::Metric.new(expression: 'ga:pageviews')
  end

  def dimension_filter
    Google::Apis::AnalyticsreportingV4::DimensionFilter.new(dimension_name: 'ga:pagePath',
                                                            operator: 'EXACT',
                                                            expressions: [@page_path])
  end

  def dimension_filter_clause
    Google::Apis::AnalyticsreportingV4::DimensionFilterClause.new(filters: [dimension_filter])
  end

  def date_range
    Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: START_DATE,
                                                      end_date: Date.today.to_s)
  end

  def report_request
    Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: ENV['GOOGLE_ANALYTICS_VIEW_ID'], # https://ga-dev-tools.appspot.com/account-explorer/
      dimensions: [dimension],
      metrics: [metric],
      dimension_filter_clauses: [dimension_filter_clause],
      date_ranges: [date_range]
    )
  end

  def get_reports_request
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(report_requests: [report_request])
  end

  def get_reports_response
    $analytics_reporting_service.batch_get_reports(get_reports_request)
  end

  def report
    get_reports_response.reports.first
  end
end
