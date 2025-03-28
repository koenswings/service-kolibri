<template>

  <div class="drive-list">
    <div v-if="drives.length === 0">
      <UiAlert
        type="info"
        :dismissible="false"
      >
        {{ noDrivesText }}
      </UiAlert>
    </div>

    <div v-else>
      <h2>
        {{ $tr('drivesFound') }}
      </h2>
      <KRadioButtonGroup>
        <KRadioButton
          v-for="drive in drives"
          :key="drive.id"
          :label="enabledDriveLabel(drive)"
          :buttonValue="drive.id"
          :currentValue="value"
          @change="$emit('input', drive.id)"
        />
      </KRadioButtonGroup>
    </div>
  </div>

</template>


<script>

  import UiAlert from 'kolibri-design-system/lib/keen/UiAlert';

  export default {
    name: 'DriveList',
    components: {
      UiAlert,
    },
    props: {
      drives: {
        type: Array,
        required: true,
      },
      mode: {
        type: String,
        required: true,
      },
      value: {
        type: String,
        required: true,
      },
    },
    data() {
      return {
        selectedDrive: '',
      };
    },
    computed: {
      noDrivesText() {
        if (this.mode === 'IMPORT') {
          return this.$tr('noImportableDrives');
        } else if (this.mode === 'IMPORT_MORE') {
          return this.$tr('noDriveWithSelectedChannelError');
        }
        return this.$tr('noExportableDrives');
      },
    },
    mounted() {
      this.selectedDrive = this.value;
    },
    methods: {
      enabledDriveLabel(drive) {
        let driveLabel = drive.name;
        if (this.enabledMsg) {
          driveLabel += ` (${this.enabledMsg(drive)})`;
        }
        return driveLabel;
      },
    },
    $trs: {
      drivesFound: {
        message: 'Drives found',
        context:
          'Refers to importing and exporting channels from external USB or disk drives that Kolibri can recognize and export channels to.',
      },
      noImportableDrives: {
        message: 'No USB or network drives with Kolibri resources are connected to the server.',
        context:
          "Error message that refers to importing resources. If the drive being used doesn't have Kolibri resources on it, then this message will display.",
      },
      noDriveWithSelectedChannelError: {
        message: 'No drives with the selected channel are connected to the server',
        context:
          'Refers to importing and exporting channels from external USB or disk drives. If no drives are found this error message displays.',
      },
      noExportableDrives: {
        message: 'Could not find a writable drive connected to the server',
        context: "Error message that displays if Kolibri can't find a drive to export data to.",
      },
    },
  };

</script>


<style lang="scss" scoped>

  .error-svg {
    margin-right: 0.2em;
    margin-bottom: -6px;
  }

  h2 {
    font-size: 1em;
  }

</style>
