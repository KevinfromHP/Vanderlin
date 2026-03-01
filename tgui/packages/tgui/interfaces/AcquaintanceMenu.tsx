import {
  Box,
  Button,
  DmIcon,
  Icon,
  Image,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { IconData } from './_common/SpriteEditor/Types/types';

type Acquaintance = {
  name: string;
  title: string; // their job title
  voice_color: string;
  pronouns: string[];
  age: string;
  species: string;
  features: string[];
  rumors: string[];
  icon: string;
  dead: BooleanLike;
};

type Data = {
  admin_mode: BooleanLike;
  acquaintances: Acquaintance[];
};

type AcquaintanceProps = {
  acquaintance: Acquaintance;
};

type AcquaintancePropsPassRest = AcquaintanceProps & {
  [key: string]: any;
};


const AcquaintanceNameAndDesc = (props: AcquaintanceProps) => {
  const { acquaintance } = props;
  let desc = [acquaintance.age, acquaintance.species, acquaintance.pronouns].filter(d => d).join()
  return desc ? (
    <Tooltip content={desc} position="bottom-start">
      <Box
        textColor= {
          acquaintance.voice_color
        }
        inline
      >
        {acquaintance.name}
      </Box>
    </Tooltip>
  ) : (
    <Box
      textColor= {
        acquaintance.voice_color
      }
    >
      {acquaintance.name}
    </Box>
  );
};

const AcquaintanceCell = (props: AcquaintanceProps) => {
  const { act, data } = useBackend<Data>();
  const { admin_mode } = data;
  const { acquaintance } = props;

  return (
    <Table.Cell className="candystripe">
      <Stack vertical>
        <Stack.Item>
          <Image
            m={1}
            src={`data:image/jpeg;base64,${acquaintance.icon}`}
            height="96px"
            width="96px"
          />
        </Stack.Item>
        <Stack.Item>
          <AcquaintanceNameAndDesc acquaintance={acquaintance} />
        </Stack.Item>
      </Stack>
      {!!admin_mode && (
        <Button
          onClick={() =>
            act('remove_acquaintance', {
              acquaintance_name: acquaintance.name,
            })
          }
        >
          Remove
        </Button>
      )}
    </Table.Cell>
  );
};

const Make_All_Acquaintances = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Button
      tooltip={`Learn the identities of everyone present in the round.`}
      onClick={() => act('make_all_acquaintances')}
    >
    Make All Acquaintances
    </Button>
  );
};

export const AcquaintanceMenu = (props) => {
  const { data } = useBackend<Data>();
  const { admin_mode, is_living, acquaintances } = data;

  // only show acquaintances we can speak OR understand, UNLESS we're an admin
  // also, push all acquaintances we can speak to the top, then all languagse we can only understand, then alphabetize
  const shown_acquaintances = acquaintances

  return (
    <Window
      title="Acquaintances"
      width={admin_mode ? 700 : 500}
      height={Math.min(
        shown_acquaintances.length * 25 + (admin_mode ? 145 : 100),
        600,
      )}
    >
      <Window.Content>
        <Section
          scrollable
          title={admin_mode ? <i>- Admin Mode -</i> : null}
          buttons={admin_mode ? <Make_All_Acquaintances /> : null}
          fill
        >
          <Table>
            <Table.Row>
              {shown_acquaintances.map((acquaintance) => (
                <AcquaintanceCell key={acquaintance.name} acquaintance={acquaintance} />
              ))}
            </Table.Row>
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
