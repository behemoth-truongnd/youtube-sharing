import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  linkDestroy(event) {
    // https://github.com/rails/jquery-ujs/blob/fafee4e1af48c7a5bf6bbed0def4afe5162626d5/src/rails.js#L215
    event.preventDefault();
    const confirmMessage = $(event.currentTarget).attr("confirm");
    if (confirmMessage) {
      const ok = confirm(confirmMessage);
      if (ok) {
        const href = event.currentTarget.href;
        const method = "delete";
        let form = $('<form method="post" action="' + href + '"></form>');
        let metadataInput =
          '<input name="_method" value="' + method + '" type="hidden" />';
        const csrfToken = document.getElementsByName("csrf-token")[0].content;
        const csrfParam = document.getElementsByName("csrf-param")[0].content;
        if (csrfParam !== undefined && csrfToken !== undefined) {
          metadataInput +=
            '<input name="' +
            csrfParam +
            '" value="' +
            csrfToken +
            '" type="hidden" />';
        }
        form.hide().append(metadataInput).appendTo("body");
        form.submit();
      }
    } else {
      const href = event.currentTarget.href;
      const method = "delete";
      let form = $('<form method="post" action="' + href + '"></form>');
      let metadataInput =
        '<input name="_method" value="' + method + '" type="hidden" />';
      const csrfToken = document.getElementsByName("csrf-token")[0].content;
      const csrfParam = document.getElementsByName("csrf-param")[0].content;
      if (csrfParam !== undefined && csrfToken !== undefined) {
        metadataInput +=
          '<input name="' +
          csrfParam +
          '" value="' +
          csrfToken +
          '" type="hidden" />';
      }
      form.hide().append(metadataInput).appendTo("body");
      form.submit();
    }
  }

  htmlSubmit(event) {
    event.preventDefault();
    $(event.currentTarget).closest("form").submit();
  }
}
