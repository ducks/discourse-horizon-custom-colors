export default {
  name: "inject-custom-colors",

  initialize(owner) {
    const currentUser = owner.lookup("service:current-user");
    if (!currentUser) {
      return;
    }

    const colorString = currentUser.custom_fields?.custom_color_string;
    if (!colorString) {
      return;
    }

    const hexRegex = /#[0-9A-Fa-f]{6}\b/g;
    const colors = colorString.match(hexRegex);
    if (!colors || colors.length === 0) {
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

    const style = document.createElement("style");
    style.id = "custom-user-colors";
    style.textContent = css;
    document.head.appendChild(style);
  },
};
