namespace Hyperar.AddFeatureFolders
{
    using System;
    using System.Collections.Generic;
    using Microsoft.AspNetCore.Mvc.Controllers;
    using Microsoft.AspNetCore.Mvc.Razor;

    public class FeatureViewLocationExpander : IViewLocationExpander
    {
        private readonly string _placeholder;

        public FeatureViewLocationExpander(FeatureFolderOptions options)
        {
            _placeholder = options.FeatureNamePlaceholder;
        }

        public void PopulateValues(ViewLocationExpanderContext context)
        {
            // see: https://stackoverflow.com/questions/36802661/what-is-iviewlocationexpander-populatevalues-for-in-asp-net-core-mvc
            context.Values["action_displayname"] = context.ActionContext.ActionDescriptor.DisplayName;
        }

        public IEnumerable<string> ExpandViewLocations(ViewLocationExpanderContext context, IEnumerable<string> viewLocations)
        {
            ArgumentNullException.ThrowIfNull(context, nameof(context));

            ArgumentNullException.ThrowIfNull(viewLocations, nameof(viewLocations));

            var controllerDescriptor = context.ActionContext.ActionDescriptor as ControllerActionDescriptor;
            var featureName = controllerDescriptor?.Properties["feature"] as string;

            foreach (var location in viewLocations)
            {
                yield return location.Replace(_placeholder, featureName);
            }
        }
    }
}