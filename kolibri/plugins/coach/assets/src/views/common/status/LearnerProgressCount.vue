<template>

  <div>
    <KLabeledIcon nowrap>
      <template #icon>
        <CoachStatusIcon
          ref="status"
          :icon="icon"
        />
      </template>
      {{ text }}
    </KLabeledIcon>
    <KTooltip
      v-if="false"
      reference="status"
      placement="top"
      :refs="$refs"
    >
      {{ tooltip }}
    </KTooltip>
  </div>

</template>


<script>

  import { coachStringsMixin } from '../commonCoachStrings';
  import CoachStatusIcon from './CoachStatusIcon';
  import { statusStringsMixin, isValidVerb } from './statusStrings';

  export default {
    name: 'LearnerProgressCount',
    components: {
      CoachStatusIcon,
    },
    mixins: [statusStringsMixin, coachStringsMixin],
    props: {
      verb: {
        type: String,
        required: true,
        validator: isValidVerb,
      },
      icon: {
        type: String,
        required: true,
      },
      showRatioInTooltip: {
        type: Boolean,
        default: false,
      },
    },
    computed: {
      strings() {
        return this.learnerProgressTranslators[this.verb];
      },
      text() {
        if (!this.verbosityNumber) {
          return this.$formatNumber(this.count);
        }
        return this.strings.$tr(this.shorten('count', this.verbosityNumber), { count: this.count });
      },
      tooltip() {
        if (this.showRatioInTooltip) {
          return this.strings.$tr(this.shorten('ratio', 2), {
            count: this.count,
            total: this.total,
          });
        }
        return this.strings.$tr(this.shorten('count', 2), { count: this.count });
      },
    },
  };

</script>


<style lang="scss" scoped></style>
