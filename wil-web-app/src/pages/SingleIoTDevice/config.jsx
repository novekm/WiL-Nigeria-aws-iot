/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router';
import { v4 as uuidv4 } from 'uuid';
import {
  Box,
  BreadcrumbGroup,
  Button,
  ButtonDropdown,
  ColumnLayout,
  Container,
  Header,
  ProgressBar,
  StatusIndicator,
  SpaceBetween,
  Table,
  MixedLineBarChart,
  PieChart
} from '@cloudscape-design/components';
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
import {
  AWSIoTProvider,
  CONNECTION_STATE_CHANGE,
  // PubSub,
  ConnectionState,
} from '@aws-amplify/pubsub';
import {
  TableEmptyState,
  InfoLink,
} from '../../common/common-components-config';

import { getIoTDevice } from '../../graphql/queries';

Hub.listen('pubsub', (data) => {
  const { payload } = data;
  if (payload.event === CONNECTION_STATE_CHANGE) {
    // const connectionState = payload.data.connectionState as ConnectionState;
    // const connectionState = payload.data.connectionState;
    console.log(payload.data.connectionState, payload);
  }
});

export const PageHeader = ({ buttons, singleIoTDevice }) => {
  return (
    <Header
      variant="h1"
      actions={
        <SpaceBetween direction="horizontal" size="xs">
          {buttons.map((button, key) =>
            !button.items ? (
              <Button
                href={button.href || ''}
                disabled={button.disabled || false}
                key={key}
              >
                {button.text}
              </Button>
            ) : (
              <ButtonDropdown items={button.items} key={key}>
                {button.text}
              </ButtonDropdown>
            )
          )}
        </SpaceBetween>
      }
    >
      {/* Reference 'singleIoTDevice' prop passed by SingleIoTDevice component in index.jsx */}
      {singleIoTDevice.DeviceName}
    </Header>
  );
};

//  - IoT Device Details Table -
// Content/formatting for the IoT Device Details table
export const IoTDeviceDeviceDetailsTableConfig = ({
  isInProgress,
  singleIoTDevice,
}) => {
  // const iotDeviceData = singleIoTDevice;
  // console.log(iotDeviceData);

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Device Name</Box>
          <div>{singleIoTDevice.DeviceName}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Device</Box>
          <div>{singleIoTDevice.Device}</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">Computer Module</Box>
          <div>{singleIoTDevice.ComputerModule}</div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Device Id</Box>
          <div>{singleIoTDevice.DeviceId}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Model</Box>
          <div>{singleIoTDevice.Model}</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">Registered Owner</Box>
          <div>{singleIoTDevice.RegisteredOwner}</div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Short Name</Box>
          <div>{singleIoTDevice.ShortName}</div>
        </div>
        {/* TODO - Use PubSub to update this in real-time */}
        {/* {singleIoTDevice.DeviceStatus ? (
          <StatusIndicator
            type={
              singleIoTDevice.DeviceStatus === 'Disconnected' ? 'error' : 'success'
            }
          >
            {singleIoTDevice.DeviceStatus}
          </StatusIndicator>
        ) : (
          <ProgressBar
            value={27}
            label="Battery"
            // description={isInProgress ? 'Update in progress' : undefined}
            variant="key-value"
            resultText="Available"
            status={isInProgress ? 'in-progress' : 'success'}
          />
        )} */}
        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Device Status</Box>
          <div>Connected</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">PrimaryLocation</Box>
          <div>{singleIoTDevice.PrimaryLocation}</div>
        </div>
      </SpaceBetween>
      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>
  );
};

// - IoT Device Commands Table -
// OPTION 1 - Content/formatting for the IoT Device Commands table
export const IoTDeviceCommandsTableConfig = ({ singleIoTDevice }) => {
  const singleIoTDeviceName = singleIoTDevice.DeviceName;
  const singleIoTDeviceId = singleIoTDevice.DeviceId;
  const singleIoTDeviceRegisteredPatient = singleIoTDevice.RegisteredPatient;

  let currentTimeObject = new Date();

  let currentTimeISO = currentTimeObject.toISOString();
  // let currentTimeLocaleString = currentTimeObject.toLocaleString();

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Movements</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'Forward'
                  }
                })
              }
            >
              Forward
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'Backward'
                  }
                })
              }
            >
              Backward
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'Left'
                  }
                })
              }
            >
              Left
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'Right'
                  }
                })
              }
            >
              Right
            </Button>
          </div>
          {/* ROW 2 */}
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'RotateCCW'
                  }
                })
              }
            >
              Turn Left
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'RotateCW'
                  }
                })
              }
            >
              Turn Right
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Row */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">Mode</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'stand'
                  },
                  move: 'stand'
                })
              }
            >
              Stand
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'sit'
                  },
                  move: 'sit'
                })
              }
            >
              Sit
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'stop'
                  },
                  move: 'stop'
                })
              }
              variant='primary'
            >
              Stop
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Actions</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'look_up'
                  },
                  move: 'look_up'
                })
              }
              // variant='primary'
            >
              Look Up
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'look_down'
                  },
                  move: 'look_down'
                })
              }
              // variant='primary'
            >
              Look Down
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'look_left'
                  },
                  move: 'look_left'
                })
              }
              // variant='primary'
            >
              Look Left
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'look_right'
                  },
                  move: 'look_right'
                })
              }
              // variant='primary'
            >
              Look Right
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleIoTDeviceId}/do`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeISO,
                  DeviceId: `${singleIoTDeviceId}`,
                  DeviceName: `${singleIoTDevice.DeviceName}`,
                  ShortName: `${singleIoTDevice.ShortName}`,
                  Manufacturer:`${singleIoTDevice.Manufacturer}`,
                  Model: `${singleIoTDevice.Model}`,
                  Device: `${singleIoTDevice.Device}`,
                  RegisteredOwner: `${singleIoTDevice.RegisteredOwner}`,
                  PrimaryLocation: `${singleIoTDevice.PrimaryLocation}`,
                  IoTTopic: `device/${singleIoTDeviceId}/do`,
                  Message: {
                      move: 'seq'
                  },
                  move: 'seq',
                  seq: ["look_left","look_right","look_down","look_up","stop"]
                })
              }
              variant='primary'
            >
              Look Around
            </Button>
            {/* TODO - Add more buttons here for 'Dance' and 'Speak'. Or have Textbox with 'submit' button for customizable speech */}
          </div>
        </div>
      </SpaceBetween>

      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> <Button>Submit</Button> */}
    </ColumnLayout>

  );
};


// Content/formatting for the IoT Device Details table
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
        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Registered Owner: {singleIoTDevice.RegisteredOwner}</Box>
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
            legendTitle="Requests over all time"
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
        {/* Second Item - Bar Chart */}
        <div>
          {/* <Box variant="awsui-key-label">Chart 1</Box> */}
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
            yDomain={[0, 20]}
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
