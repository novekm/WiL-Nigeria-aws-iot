/* eslint-disable no-console */
/* eslint-disable no-unused-vars */
/* eslint-disable no-use-before-define */
/* eslint-disable no-undef */
/* eslint-disable react/prop-types */
/* eslint-disable import/order */
/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */

import React, { useState, useEffect } from 'react';

// - CLOUDSCAPE -
import {
  // Alert,
  BreadcrumbGroup,
  Button,
  // Flashbar,
  AppLayout,
  Container,
  Header,
  HelpPanel,
  Grid,
  Box,
  Icon,
  TextContent,
  ContentLayout,
  SpaceBetween,
} from '@cloudscape-design/components';

// - COMMON -
import {
  // Notifications,
  ExternalLinkItem,
  // TableHeader,
} from '../../common/common-components-config';
import Sidebar from '../../common/components/Sidebar';
import { resourcesBreadcrumbs } from './breadcrumbs';

// - CORE COMPONENTS -
import { Overview } from './Overview';
import { EmissionsLineChart } from './S3ObjectsLineChart';
import { IoTDeviceMetricsTableConfig,} from './config'
import MessagesTable from './MessagesTable'

// - STYLES -
// import '../../common/styles/dashboard.scss';
import '../../common/styles/intro.scss';
import '../../common/styles/servicehomepage.scss';

// - ASSETS -
import awsLogo from '../../public/images/AWS_logo_RGB_REV.png';

// - AMPLIFY -
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
import { withAuthenticator } from '@aws-amplify/ui-react';
import {
  AWSIoTProvider,
  CONNECTION_STATE_CHANGE,
  ConnectionState,
} from '@aws-amplify/pubsub';

// - API FUNCTIONS -
import {
  getIoTDevice,
  listIoTDevices,
  getIoTMessage,
  listIoTMessages,
} from '../../graphql/queries';


const Dashboard = ({ user }) => {

  return (
    <AppLayout
      breadcrumbs={<Breadcrumbs />}
      navigation={<Sidebar activeHref="/dashboard" />}
      content={
        // <ContentLayout header={<DashboardHeader />}>
        //   <Content />
        // </ContentLayout>
        <Content user={user} />
      }
      tools={<ToolsContent />}
      headerSelector="#h"
      disableContentPaddings
    />
  );
};

export default withAuthenticator(Dashboard);

const Content = ({ user, isInProgress }) => {
  const [iotDevices, setIoTDevices] = useState([]);
  const [singleIoTDevice, setSingleIoTDevice] = useState([]);
  const [iotMessages, setIoTMessages] = useState([]);
  const [lastTwelveMonth, setLastTwelveMonth] = useState([]);
  const [qualifiedMonthMap, setQualifiedMonths] = useState([]);
  const [pieChart, setPieChart] = useState([]);

  // Fetch all IoTDevices in the MPC DynamoDB Metadata Table
  const fetchIoTDevices = async () => {
    try {
      const IoTDeviceData = await API.graphql(
        graphqlOperation(listIoTDevices, { limit: 10000 }) // limit fetch to 1000 items
      );
      const IoTDeviceDataList = IoTDeviceData.data.listIoTDevices.devices;
      console.log('IoT Device List', IoTDeviceDataList);
      setIoTDevices(IoTDeviceDataList);
    } catch (error) {
      console.log('error on fetching IoT Devices', error);
    }
  };

  // Fetch data for all IoT messages in the MPC MQTT DynamoDB table
  const fetchIoTMessages = async () => {
    try {
      const iotMessagesData = await API.graphql(
        graphqlOperation(listIoTMessages, { limit: 10000 })
      );

      const iotMessagesDataList = iotMessagesData.data.listIoTMessages.messages;
      console.log('IoTMessagesFromDynamoDB<SingleIoTDevice/index.jsx>', iotMessagesDataList);
      getPieChartMap(iotMessagesDataList);
      getLastTwelveMonthAndQualifiedMonths(iotMessagesDataList);
      setIoTMessages(iotMessagesDataList);
      // setLoading(false)
    } catch (error) {
      console.log('error on fetching IoT Messages', error);
    }
  };

    // Get messages list for PieChart graph
    const getPieChartMap = async (iotMessages) => {
      const iotMessagesList = iotMessages.map((iotMessage) => iotMessage.Message);
      const pieChartMap = iotMessagesList.reduce((acc, curr) => {
        acc[curr] = (acc[curr] || 0) + 1;
        return acc;
      }, {});

      setPieChart(pieChartMap);
  }

  // Get the last 12 months from today's date
  const getLastTwelveMonthAndQualifiedMonths = async (iotMessages) => {
    var theMonths = new Array("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December");
    var now = new Date();
    const lastTwelveMonth = [];
    for (var i = 0; i > -12; i--) {
      var past = new Date(now.getFullYear(), now.getMonth() + i, 1);
      var month = theMonths[past.getMonth()];
      var year = past.getFullYear().toString();
      lastTwelveMonth.unshift(month + ' ' + year);
    }

    // Get intersection of last 12 months and months in our dataset
    const timeStamps = iotMessages.map((iotMessage) => new Date(iotMessage.Timestamp)
                                  .toLocaleString('default', { month: 'long' }) + " " + new Date(iotMessage.Timestamp)
                                  .getFullYear());
    const qualifiedMonths = timeStamps.filter((x) => lastTwelveMonth.includes(x));
    const qualifiedMonthMap = qualifiedMonths.reduce((acc, curr) => {
      acc[curr] = (acc[curr] || 0) + 1;
      return acc;
    }, {});

    setQualifiedMonths(qualifiedMonthMap);
    setLastTwelveMonth(lastTwelveMonth);
  }

  // Subscribe to the specific topic relating to the current IoTDevice on the page on page load
  useEffect(() => {
    fetchIoTDevices();
    fetchIoTMessages();

    const sub = PubSub.subscribe(`device/${singleIoTDevice.DeviceId}/data`).subscribe({
      next: (data) => console.log('Message received', data),
      error: (error) => console.error(error),
      complete: () => console.log('Done'),
    });
    console.log('subscribe');
    console.log(`${singleIoTDevice.DeviceName}`);
    return () => {
      sub.unsubscribe();
    };
  }, []);





  // eslint-disable-next-line react/jsx-no-useless-fragment
  return (
    <>
      <TextContent>
        <div>
          <Grid className="custom-home__header" disableGutters>
            <Box margin="xxl" padding={{ vertical: '', horizontal: 'l' }}>
              <Box margin={{ bottom: 's' }} />
              <img
                src={awsLogo}
                alt=""
                style={{ maxWidth: '10%', paddingRight: '2em' }}
                // style={{ maxWidth: '20%', paddingRight: '2em' }}
              />
              <div className="custom-home__header-title">
                <Box fontSize="display-l" fontWeight="bold" color="inherit">
                  Hi, {user.attributes.given_name} 👋
                </Box>
                <Box
                  fontSize="heading-l"
                  padding={{ bottom: 's' }}
                  fontWeight="light"
                  color="inherit"
                >
                  Ready to get the day started?
                </Box>
              </div>
            </Box>
          </Grid>
        </div>
      </TextContent>
      <Overview iotDevices={iotDevices} />
      {/* <EmissionsBarChart s3ObjectsMonthlyTotal={filteredS3ObjectsTotal2022} /> */}
      {/* <EmissionsLineChart /> */}
      <Box margin="xxl" padding={{ vertical: '', horizontal: 'l' }}>
        <MessagesTable
          iotMessages={iotMessages}
        />
      </Box>
      {/* Metrics Table Config (Charts) */}
      <Box margin="xxl" padding={{ vertical: '', horizontal: 'l' }}>
        <Container>
          <IoTDeviceMetricsTableConfig
            // Pass singleIoTDevice data as prop
            singleIoTDevice={singleIoTDevice}
            isInProgress={isInProgress}
            lastTwelveMonth={lastTwelveMonth}
            qualifiedMonthMap={qualifiedMonthMap}
            pieChart={pieChart}
            />
          </Container>
      </Box>

    </>
  );
};


export const Breadcrumbs = () => (
  <BreadcrumbGroup
    items={resourcesBreadcrumbs}
    expandAriaLabel="Show path"
    ariaLabel="Breadcrumbs"
  />
);

export const ToolsContent = () => (
  <HelpPanel
    header={<h2>Dashboard</h2>}
    footer={
      <>
        <h3>
          Learn more{' '}
          <span role="img" aria-label="Icon external Link">
            <Icon name="external" />
          </span>
        </h3>
        <ul>
          <li>
            <ExternalLinkItem
              href="https://aws.amazon.com/energy/"
              text="AWS Energy & Utilities"
            />
          </li>
          <li>
            <ExternalLinkItem
              href="https://github.com/novekm/minipupper-iot"
              text="MiniPupper IoT GitHub Repo"
            />
          </li>
        </ul>
      </>
    }
  >
    <p>
      The dashboard page serves as your single pane of glass into your relevant
      data points.
    </p>
  </HelpPanel>
);
