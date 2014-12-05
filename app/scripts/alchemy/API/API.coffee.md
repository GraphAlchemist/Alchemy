    # Alchemy.js is a graph drawing application for the web.
    # Copyright (C) 2014  GraphAlchemist, Inc.

    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU Affero General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU Affero General Public License for more details.

    # You should have received a copy of the GNU Affero General Public License
    # along with this program.  If not, see <http://www.gnu.org/licenses/>.

    class API
        constructor: (instance)->
            @a = instance

            # API Methods
            @get    = @Get instance,    @
            @create = @Create instance, @
            @set    = @Set instance,    @
            @remove =  Remove.remove

            @force = @Force instance, @

            @filter = @Filter instance, @
            @search = @Search instance, @

            # Internal selection tracking for method chaining
            @_el        = []
            @_elType    = null
            @_makeChain = (inp, endpoint)->
                @__proto__ = [].__proto__
                endpoint.__proto__ = [].__proto__

                @pop() while @.length
                endpoint.pop() while endpoint.length

                @push(e) for e in inp
                Array::push.apply endpoint, @_el

                _.extend endpoint, @