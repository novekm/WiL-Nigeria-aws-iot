/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import {
  Box,
  Button,
  ColumnLayout,
  SpaceBetween,
  MixedLineBarChart,
  PieChart
} from '@cloudscape-design/components';


// Content/formatting for the IoT Device Metrics table
export const IoTDeviceMetricsTableConfig = ({
  isInProgress,
  singleIoTDevice,
  iotMessages,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  const iotDeviceData = singleIoTDevice;
  console.log('MessagesTable/config.jsx', iotDeviceData);

  return (
    <ColumnLayout columns={1} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* Pie Chart */}
        <div>
          <Box variant="awsui-key-label">Messages over all time</Box>
          {/* <Box variant="awsui-key-label">Chart 1</Box> */}
            <PieChart
              data={Object.keys(pieChart).map(key =>
                ({
                  title: key,
                  value: pieChart[key]
                }))}
              detailPopoverContent={(datum, sum) => [
                { key: "Count", value: datum.value },
                {
                  key: "Percentage",
                  value: `${((datum.value / sum) * 100).toFixed(
                    0
                  )}%`
                }
              ]}
              // segmentDescription={(datum) =>
              //   `${datum.value}`
              // }
              ariaDescription="Pie chart showing button pressed proportions."
              ariaLabel="Pie chart"
              size="large"
              // legendTitle="Requests over all time"
              hideFilter
              hideTitles
              empty={
                <Box textAlign="center" color="inherit">
                  <b>No data available</b>
                  <Box variant="p" color="inherit">
                    There is no data available
                  </Box>
                </Box>
              }
              noMatch={
                <Box textAlign="center" color="inherit">
                  <b>No matching data</b>
                  <Box variant="p" color="inherit">
                    There is no matching data to display
                  </Box>
                  <Button>Clear filter</Button>
                </Box>
              }
            />
        </div>
        {/* Bar Chart */}
        <div>
          {/* <Box variant="awsui-key-label">Requests over last year</Box> */}
          {/* <Box variant="awsui-key-label">Chart 2</Box> */}
            <MixedLineBarChart
              series={[
                {
                  title: "Buttons pressed",
                  type: "bar",
                  data: Object.keys(qualifiedMonthMap).map(key =>
                    ({
                      x: key,
                      y: qualifiedMonthMap[key]
                    }))
                },
                {
                  title: "Buttons last year",
                  type: "line",
                  data: Object.keys(qualifiedMonthMap).map(key =>
                      ({
                        x: key,
                        y: qualifiedMonthMap[key]
                      }))
                }
              ]}
              xDomain={
                lastTwelveMonth.map((monthYear) => monthYear)
              }
              yDomain={[0, 200]}
              i18nStrings={{
                yTickFormatter: function s(t) {
                  return Math.abs(t) >= 1e9
                    ? (t / 1e9).toFixed(1).replace(/\.0$/, "") +
                        "G"
                    : Math.abs(t) >= 1e6
                    ? (t / 1e6).toFixed(1).replace(/\.0$/, "") +
                      "M"
                    : Math.abs(t) >= 1e3
                    ? (t / 1e3).toFixed(1).replace(/\.0$/, "") +
                      "K"
                    : t.toFixed(0);
                }
              }}
              ariaLabel="Mixed bar chart"
              height={300}
              xScaleType="categorical"
              yTitle="Number of requests over last 12 months"
              hideFilter
              empty={
                <Box textAlign="center" color="inherit">
                  <b>No data available</b>
                  <Box variant="p" color="inherit">
                    There is no data available
                  </Box>
                </Box>
              }
              noMatch={
                <Box textAlign="center" color="inherit">
                  <b>No matching data</b>
                  <Box variant="p" color="inherit">
                    There is no matching data to display
                  </Box>
                  <Button>Clear filter</Button>
                </Box>
              }
            />
        </div>

      </SpaceBetween>
    </ColumnLayout>
  );
};
