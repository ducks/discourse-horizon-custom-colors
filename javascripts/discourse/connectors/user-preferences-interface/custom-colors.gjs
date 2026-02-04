import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { on } from "@ember/modifier";
import { fn, get } from "@ember/helper";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";

export default class CustomColors extends Component {
  @service currentUser;
  @tracked colorString = "";
  @tracked saving = false;
  @tracked saved = false;

  constructor() {
    super(...arguments);
    this.colorString = this.currentUser?.custom_fields?.custom_color_string || "";
  }

  get colors() {
    const hexRegex = /#[0-9A-Fa-f]{6}\b/g;
    const matches = this.colorString.match(hexRegex);
    return matches || [];
  }

  get colorLabels() {
    return [
      "primary",
      "secondary",
      "tertiary",
      "header-bg",
      "header-text",
      "highlight",
    ];
  }

  @action
  updateColorString(event) {
    this.colorString = event.target.value;
    this.saved = false;
  }

  @action
  async saveColors() {
    this.saving = true;
    try {
      await ajax(`/u/${this.currentUser.username}.json`, {
        type: "PUT",
        data: {
          custom_fields: {
            custom_color_string: this.colorString,
          },
        },
      });
      this.currentUser.custom_fields.custom_color_string = this.colorString;
      this.saved = true;

      // Apply colors immediately
      this.applyColors();
    } catch (e) {
      console.error("Failed to save custom colors:", e);
    } finally {
      this.saving = false;
    }
  }

  @action
  clearColors() {
    this.colorString = "";
    this.saved = false;
  }

  applyColors() {
    const colors = this.colors;
    if (colors.length === 0) {
      const existing = document.getElementById("custom-user-colors");
      if (existing) {
        existing.remove();
      }
      return;
    }

    const cssVars = [
      "--primary",
      "--secondary",
      "--tertiary",
      "--header_background",
      "--header_primary",
      "--highlight",
    ];

    let css = ":root {\n";
    colors.forEach((color, index) => {
      if (cssVars[index]) {
        css += `  ${cssVars[index]}: ${color} !important;\n`;
      }
    });
    css += "}";

    let style = document.getElementById("custom-user-colors");
    if (!style) {
      style = document.createElement("style");
      style.id = "custom-user-colors";
      document.head.appendChild(style);
    }
    style.textContent = css;
  }

  <template>
    <div class="control-group custom-colors-settings">
      <label class="control-label">{{i18n "custom_colors.title"}}</label>
      <div class="controls">
        <p class="instructions">{{i18n "custom_colors.instructions"}}</p>
        <input
          type="text"
          class="custom-colors-input"
          placeholder="#1a1a2e #16213e #0f3460 #e94560 #ffffff #ffd700"
          value={{this.colorString}}
          {{on "input" this.updateColorString}}
        />

        {{#if this.colors.length}}
          <div class="color-preview">
            {{#each this.colors as |color index|}}
              <div class="color-swatch" style="background-color: {{color}}">
                <span class="color-label">
                  {{#if (get this.colorLabels index)}}
                    {{get this.colorLabels index}}
                  {{else}}
                    {{color}}
                  {{/if}}
                </span>
              </div>
            {{/each}}
          </div>
        {{/if}}

        <div class="custom-colors-actions">
          <button
            type="button"
            class="btn btn-primary"
            disabled={{this.saving}}
            {{on "click" this.saveColors}}
          >
            {{#if this.saving}}
              {{i18n "saving"}}
            {{else if this.saved}}
              {{i18n "saved"}}
            {{else}}
              {{i18n "save"}}
            {{/if}}
          </button>

          {{#if this.colorString}}
            <button
              type="button"
              class="btn btn-default"
              {{on "click" this.clearColors}}
            >
              {{i18n "custom_colors.clear"}}
            </button>
          {{/if}}
        </div>
      </div>
    </div>
  </template>
}
