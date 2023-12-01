/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */

import React from 'react';

import {
  AppLayout,
  Container,
  Header,
  HelpPanel,
  Grid,
  Box,
  TextContent,
  SpaceBetween,
  Icon,
} from '@cloudscape-design/components';
import Sidebar from '../../common/components/Sidebar';

import { ExternalLinkItem } from '../../common/common-components-config';

import '../../common/styles/intro.scss';
import '../../common/styles/servicehomepage.scss';

// Import images
import awsLogo from '../../public/images/AWS_logo_RGB_REV.png';
import mpcBasicArch from '../../../../resources/architecture/MPC_BASIC_ARCH.png';
import mpcBasicArchWithKey from '../../../../resources/architecture/MPC_BASIC_ARCH_WITH_KEY.png';

const GettingStarted = () => {
  return (
    <AppLayout
      navigation={<Sidebar activeHref="#/" />}
      // navigation={<Sidebar activeHref="#/" items={navItems}/>}
      content={<Content />}
      tools={<ToolsContent />}
      headerSelector="#h"
      disableContentPaddings
      // toolsHide={true}
    />
  );
};

export default GettingStarted;

const Content = () => {
  return (
    <div>
      <TextContent>
        <div>
          <Grid className="custom-home__header" disableGutters>
            <Box margin="xxl" padding={{ vertical: 'xl', horizontal: 'l' }}>
              <Box margin={{ bottom: 's' }} />
              <img
                src={awsLogo}
                alt=""
                style={{ maxWidth: '20%', paddingRight: '2em' }}
              />
              <div className="custom-home__header-title">
                <Box fontSize="display-l" fontWeight="bold" color="inherit">
                  Mini Pupper Control
                </Box>
                <Box
                  fontSize="display-l"
                  padding={{ bottom: 's' }}
                  fontWeight="light"
                  color="inherit"
                >
                  Improving worker safety, with a robotic puppy.
                </Box>
                <Box fontWeight="light">
                  <span className="custom-home__header-sub-title">
                    This solution serves as an example of how you can use AWS IoT
                    Core (and other services) to build a connected worker safety solution with Mini Pupper 2 robots, and an ESP32.
                    <br />
                    <br />
                    Click{' '}
                    <a
                      target="_blank"
                      rel="noopener noreferrer"
                      href="https://github.com/novekm/minipupper-iot"
                    >
                      here
                    </a>{' '}
                    to learn more.
                  </span>
                </Box>
              </div>
            </Box>
          </Grid>
        </div>

        {/* Start 'This project is buit' section */}
        <Box margin="xxl" padding="l">
          <SpaceBetween size="l">
            <div>
              <h1>About Mini Pupper Control</h1>
              <Container>
                <div>
                  <p>
                    This solution serves as an example of how you can use AWS IoT
                    Core (and other services) to build a connected worker safety solution with Mini Pupper 2 robots, and an ESP32. When a simulated toxin is detected by the Gas Sensor (M5StickC-Plus), the Mini Pupper will respond. You can also issue commands to the Mini Pupper via the details page for each specific device.

                  </p>
                  <br/>
                  Core Contributors:
                  <br />
                    <li><b>Kevon Mayers:</b> Project Lead, Terraform deployment & Full Stack Web App </li>
                    <li><b>Adam Purdie:</b> Mini Pupper Development, MQTT to ROS bridge development</li>
                  <br />
                    <b>This project provides the following:</b>
                    <li>Mini Pupper Control custom AWS Amplify Application</li>
                    <li>Mini Pupper Control AWS AppSync GraphQL API</li>
                    <li>AWS IoT Connectivity</li>
                    <li>Dynamic creation of IoT Things, Policies, Permissions, etc. with Terraform</li>
                    <li>Authentication, Authorization, and Auditing</li>
                </div>
              </Container>
            </div>
            <div>
              <h1>Architecture</h1>
              <Container header={<Header>Basic Architecture</Header>}>
                {/* Make this flex later. maxWidth is not mobile responsive */}
                <div>
                  <img
                    // src={mpcBasicArch}
                    src={mpcBasicArchWithKey}
                    alt=""
                    style={{ maxWidth: '100%', paddingRight: '2em' }}
                  />
                </div>
                <div>{/* <p>This is the basic architecture.</p> */}</div>
              </Container>
              {/* <Container header={<Header>Detailed Architecture</Header>}>
                <div>
                  <img
                    src={iacAdvancedArch}
                    alt=""
                    style={{ maxWidth: '100%', paddingRight: '2em' }}
                  />
                </div>
              </Container> */}
            </div>
          </SpaceBetween>
        </Box>
      </TextContent>
    </div>
  );
};

export const ToolsContent = () => (
  <HelpPanel
    header={<h2>About</h2>}
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
      This solution serves as an example of how you can use AWS IoT
                    Core (and other services) to build a connected worker safety solution with Mini Pupper 2 robots.
      <br />
      <br />
      <span>
        The app is built leveraging AWS Amplify, Cloudscape, Terraform, and the
        AWS Amplify Libraries for JavaScript. For more information, see
      </span>
      <a
        target="_blank"
        rel="noopener noreferrer"
        href="https://docs.amplify.aws/lib/q/platform/js/"
      >
        {' '}
        AWS Amplify Libraries for JavaScript,
      </a>
      <span> and</span>
      <a
        target="_blank"
        rel="noopener noreferrer"
        href="https://cloudscape.design/"
      >
        {' '}
        Cloudscape
      </a>
    </p>
  </HelpPanel>
);
