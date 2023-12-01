/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';

// - CLOUDSCAPE -
import {
  BreadcrumbGroup,
  Button,
  AppLayout,
  Container,
  Header,
  HelpPanel,
  Icon,
  SpaceBetween,
  ContentLayout,
} from '@cloudscape-design/components';

// - COMMON -
import {
  ExternalLinkItem,
  InfoLink,
  Navigation,
  TableHeader,
} from '../../common/common-components-config';
import Sidebar from '../../common/components/Sidebar';

// - CORE COMPONENTS -
import {
  PageHeader,
  IoTDeviceDeviceDetailsTableConfig,
  IoTDeviceCommandsTableConfig,
  IoTDeviceMetricsTableConfig,
  // IoTDeviceCommandsTableConfig2,
} from './config';
import MessagesTable from './MessagesTable'

// - STYLES -
import '../../common/styles/base.scss';

// - ASSETS -

// - AMPLIFY -
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
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
  listIoTMessagesByDeviceId,
} from '../../graphql/queries';


// Main component for page
const SingleIoTDevice = () => {
  const [toolsOpen, setToolsOpen] = useState(false);
  const { DeviceId } = useParams();
  const [singleIoTDevice, setSingleIoTDevice] = useState([]);
  const [iotMessages, setIoTMessages] = useState([]);
  const [lastTwelveMonth, setLastTwelveMonth] = useState([]);
  const [qualifiedMonthMap, setQualifiedMonths] = useState([]);
  const [pieChart, setPieChart] = useState([]);

  // Fetch data for one IoT Device by 'DeviceId' specified in browser URL via useParams hook
  const fetchSingleIoTDevice = async () => {
    try {
      const singleIoTDeviceData = await API.graphql(
        graphqlOperation(getIoTDevice, { DeviceId: `${DeviceId}` })
      );
      const singleIoTDeviceDataList = singleIoTDeviceData.data.getIoTDevice;
      console.log('Single IoT Device List', singleIoTDeviceDataList);
      setSingleIoTDevice(singleIoTDeviceDataList);
      // setLoading(false)
    } catch (error) {
      console.log('error on fetching single IoT Device', error);
    }
  };
  // // Fetch data for all IoT messages in the MPC MQTT DynamoDB table
  // const fetchIoTMessages = async () => {
  //   try {
  //     const iotMessagesData = await API.graphql(
  //       graphqlOperation(listIoTMessages, { limit: 10000 })
  //     );

  //     const iotMessagesDataList = iotMessagesData.data.listIoTMessages.messages;
  //     console.log('IoTMessagesFromDynamoDB<SingleIoTDevice/index.jsx>', iotMessagesDataList);
  //     getPieChartMap(iotMessagesDataList);
  //     getLastTwelveMonthAndQualifiedMonths(iotMessagesDataList);
  //     setIoTMessages(iotMessagesDataList);
  //     // setLoading(false)
  //   } catch (error) {
  //     console.log('error on fetching IoT Messages', error);
  //   }
  // };
  // Fetch data for all IoT messages filtered by DeviceId in the IoT MQTT DynamoDB table
  const fetchIoTMessagesByDeviceId = async () => {
    try {
      const iotMessagesData = await API.graphql(
        graphqlOperation(listIoTMessagesByDeviceId, {DeviceId: DeviceId, limit: 10000 })
      );

      const iotMessagesDataList = iotMessagesData.data.listIoTMessagesByDeviceId.messages;
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

  // Run the fetchSingleIoTDevice() function on page load
  // useEffect(() => {
  // }, []);

  // Subscribe to the specific topic relating to the current IoT Device on the page on page load
  useEffect(() => {
    fetchSingleIoTDevice();
    // fetchIoTMessages();
    fetchIoTMessagesByDeviceId();

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
  // Subscribe to the specific global topic relating to the current IoT Device on the page on page load
  useEffect(() => {
    const sub = PubSub.subscribe(
      `${singleIoTDevice.DeviceName}/sub-global`
    ).subscribe({
      next: (data) => console.log('Message received', data),
      error: (error) => console.error(error),
      complete: () => console.log('Done'),
    });
    return () => {
      sub.unsubscribe();
    };
  }, []);

  return (
    <AppLayout
      navigation={<Sidebar activeHref="/iot-devices" />}
      // notifications={<Notifications successNotification={false} />}
      breadcrumbs={<Breadcrumbs singleIoTDevice={singleIoTDevice} />} // define these values in /breadcrumbs/index.js
      content={
        <ContentLayout
          header={
            <PageHeader
              singleIoTDevice={singleIoTDevice}
              buttons={[{ text: 'IoT Devices', href: '/iot-devices' }]}
              // buttons={[{ text: 'Edit' }, { text: 'Delete' }]}
              // loadHelpPanelContent={this.loadHelpPanelContent.bind(this)}
            />
          }
        >
          <SpaceBetween size="l">
            <IoTDeviceDeviceDetailsTable
              singleIoTDevice={singleIoTDevice}
              isInProgress
              lastTwelveMonth={lastTwelveMonth}
              qualifiedMonthMap={qualifiedMonthMap}
              pieChart={pieChart}
            />
          </SpaceBetween>
            <MessagesTable
              singleIoTDevice={singleIoTDevice}
              iotMessages={iotMessages}
              />
          <SpaceBetween size="l">
            <IoTDeviceDeviceMetricsTable
              singleIoTDevice={singleIoTDevice}
              isInProgress
              lastTwelveMonth={lastTwelveMonth}
              qualifiedMonthMap={qualifiedMonthMap}
              pieChart={pieChart}
            />
          </SpaceBetween>
        </ContentLayout>

      }
      contentType="table"
      tools={<ToolsContent />}
      toolsOpen={toolsOpen}
      onToolsChange={({ detail }) => setToolsOpen(detail.open)}
      stickyNotifications
    />
  );
};

export default SingleIoTDevice;

// IoT Device Device Details Table - Configuration is in config.jsx
const IoTDeviceDeviceDetailsTable = ({
  singleIoTDevice,
  iotMessages,
  loadHelpPanelContent,
  isInProgress,
  setToolsOpen,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  return (
    <>
      <Container
        header={
          <Header variant="h2">
            Device Details
          </Header>
        }
        >
        <IoTDeviceDeviceDetailsTableConfig
          // Pass singleIoTDevice data as prop
          singleIoTDevice={singleIoTDevice}
          isInProgress={isInProgress}
          />
        <IoTDeviceCommandsTableConfig singleIoTDevice={singleIoTDevice} />
        {/* Option 2 for commands layout */}
        {/* <IoTDeviceCommandsTableConfig2 /> */}
      </Container>
    </>
  );
};
// IoTDevice Device Details Table - Configuration is in config.jsx
const IoTDeviceDeviceMetricsTable = ({
  singleIoTDevice,
  iotMessages,
  loadHelpPanelContent,
  isInProgress,
  setToolsOpen,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  return (
    <>
      <Container
        header={
          <Header variant="h2">
            Device Metrics
          </Header>
        }
        >
        <IoTDeviceMetricsTableConfig
          // Pass singleIoTDevice data as prop
          singleIoTDevice={singleIoTDevice}
          isInProgress={isInProgress}
          lastTwelveMonth={lastTwelveMonth}
          qualifiedMonthMap={qualifiedMonthMap}
          pieChart={pieChart}
          />

      </Container>
      {/* <Container>
      </Container> */}
        {/* <MessagesTable
          iotMessages={iotMessages}
        /> */}
    </>
  );
};

export const Breadcrumbs = ({ singleIoTDevice }) => (
  <BreadcrumbGroup
    items={[
      {
        text: 'Mini Pupper Control',
        href: '/dashboard',
      },
      {
        text: 'IoT Device',
        href: '/iot-devices',
      },
      {
        text: `${singleIoTDevice.DeviceName}`,
        href: '#',
      },
    ]}
    expandAriaLabel="Show path"
    ariaLabel="Breadcrumbs"
  />
);

// Info pop out window seen when clicking 'info' or the i in a circle button on right side of page
export const ToolsContent = () => (
  <HelpPanel
    header={<h2>Device Details</h2>}
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
      This page is a view into your selected IoT Device and related information such
      as the Device Name, Device Id, Device Status, Registered Owner, Registered Location, and more.
    </p>
  </HelpPanel>
);
