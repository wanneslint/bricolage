<div id="element_<% $id %>_content" class="content">
% unless ($top_level) {
<fieldset>
<legend class="name"><% $element->get_name %>:</legend>
% }
% if ($type->is_related_story) {
<div id="element_<% $id %>_rel_story">
    <& '_related.html',
        widget => $widget,
        container => $element,
        type => 'story',
        asset => $story
    &>
</div>
% }
% if ($type->is_related_media) {
<div id="element_<% $id %>_rel_media">
    <& '_related.html',
        widget => $widget,
        container => $element,
        type => 'media',
        asset => $story
    &>
</div>
% }
<ul id="element_<% $id %>" class="elements">
% foreach my $dt ($element->get_elements()) {
%   if ($dt->is_container) {
    <li id="subelement_con<% $dt->get_id %>" class="container clearboth">
    <& 'container.mc',
        widget  => $widget,
        element => $dt
    &>
    </li>
%   } else {
    <li id="subelement_dat<% $dt->get_id %>" class="element clearboth">
    <& 'field.mc',
        widget  => $widget,
        element => $dt
    &>
    </li>
%   }
% }
</ul>
<input type="hidden" name="container_prof|element_<% $id %>" id="container_prof_element_<% $id %>" value="" />
<script type="text/javascript">
Sortable.create('element_<% $id %>', { 
    onUpdate: function(elem) { 
        Container.updateOrder(elem); 
    }, 
    handle: 'name' 
});
Container.updateOrder('element_<% $id %>');
</script>

<div class="actions">
%   if (scalar @$elem_opts) {
%   # XXX mroch: Don't leave this hard-coded! Make a component.
    <div class="clearboth" style="float: left; position: relative;">
    <button id="element_<% $id %>_add" onclick="Desk.showMenu(this, event); return false"><img src="/media/images/add-element.png" alt="Add Element" /> Add Element</button>
    <div id="element_<% $id %>_add_desks" class="popup-menu" style="left: 0; right: auto; width: auto; display: none; padding: 0;">
        <ul>
%           foreach my $opt (@$elem_opts) {
            <li><a href="#" onclick="Container.addElement(<% $id %>, '<% $opt->[0] %>'); return false"><% $opt->[1] %></a></li>
%           }
        </ul>
    </div>
    </div>
%   }

<button id="<% $top_level ? 'bulk_edit_this_cb' : 'bulk_edit_' . $id %>" name="container_prof|<% $top_level ? 'bulk_edit_this_cb' : 'bulk_edit_cb' %>" value="<% $id %>">
    <img src="/media/images/bulk-edit.png" alt="Bulk Edit" /> Bulk Edit
</button>
</div>
% unless ($top_level) {
</fieldset>
% }

% unless ($top_level) {
<div class="delete">
    <& '/widgets/profile/button.mc',
        disp      => $lang->maketext("Delete"),
        name      => 'delete_' . $name,
        button    => 'delete',
        extension => 'png',
        globalImage => 1,
        js        => qq|onclick="Container.deleteElement(| . $element->get_parent_id . qq|, '$name'); return false;"|,
        useTable  => 0 
    &>
</div>
% }

</div>

<%args>
$widget
$element
</%args>

<%init>
my $story = get_state_data('story_prof', 'story');
my $type = $element->get_element_type;
my $id   = $element->get_id;
my $name = 'con' . $id;
my $top_level = (get_state_data($widget, 'element') == $element);

# Get the list of fields and subelements that can be added.
my $elem_opts = [
    map  { $_->[1] }
    sort { $a->[0] cmp $b->[0] }
    map  {
        my $key = $_->can('get_sites') ? 'cont_' : 'data_';
        [ lc $_->get_name => [ $key . $_->get_id => $_->get_name ] ]
    }
        $element->get_possible_field_types,
        grep { chk_authz($_, READ, 1) } $element->get_possible_containers
];
</%init>